Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9252DFF04;
	Sun,  7 Jun 2026 10:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829298; cv=none; b=ltqYBVfXHuNa3WNIGsjw8OI1TCj+4EdrOqBYGio02tY3JqGQi3q7VoRn0io/tIc7ws7VESGVFscGfFItqjuRT5av6B8fhkI84IHOra2IIGCZPAXQL5Gj9kieInxnnsQtl4EC0frld3ywnkFmgS8Y5I5eks0xIh6DcqgUWAxxAac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829298; c=relaxed/simple;
	bh=KndTnL63RVyHZvrKiioCnHulmeB5ggv0BI2qCLLS2d0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FlLJbu67jhB39P+oVpVE/2a6xISjsJ9FOdpJqo54anSxf0F+GR0GOhrRZXuuXqlBT5/IBXy24PziM7+4u5sLboCYQmia/3or+S/Pn8/wlVg7pttTxeG80L2CCsvGMfp/RVUPQT/mi9vbF71Ycbb2DMjanBO/8YzyqKtVKYrTwTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vGSmLAgf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vGSmLAgf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E9561F00893;
	Sun,  7 Jun 2026 10:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829297;
	bh=3JVQaYBobZ9QYGEzyJoKv2iHiv7aS4RKKoxsrBw1U54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vGSmLAgfcdxI/FWPhRxoZz55Mf0CiCoSQvvhRcBpcujKay4YcaannoeFGcGkaqdik
	 hBNtVzLIOQbcyYyLULNlZ4gIuZuxeTDhbT2aBnBBWDymDu5gtg9GfzzhOaTTC1rmOr
	 HRUSU/rkZ7Y8vrMIJknG4yNmazPIPFvj5v1n0Gx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	William Breathitt Gray <wbg@kernel.org>
Subject: [PATCH 6.12 212/307] counter: Fix refcount leak in counter_alloc() error path
Date: Sun,  7 Jun 2026 12:00:09 +0200
Message-ID: <20260607095735.505110115@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit d9eeb0ea0d2de658663bfaa9c26eccdd8fd64440 upstream.

After device_initialize(), the lifetime of the embedded struct device
is expected to be managed through the device core reference counting.

In counter_alloc(), if dev_set_name() fails after device_initialize(),
the error path removes the chrdev, frees the ID, and frees the backing
allocation directly instead of releasing the device reference with
put_device(). This bypasses the normal device lifetime rules and may
leave the reference count of the embedded struct device unbalanced,
resulting in a refcount leak.

The issue was identified by a static analysis tool I developed and
confirmed by manual review.

Fix this by using put_device() in the dev_set_name() failure path and
let counter_device_release() handle the final cleanup.

Fixes: 4da08477ea1f ("counter: Set counter device name")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://lore.kernel.org/r/20260413134604.2861772-1-lgs201920130244@gmail.com
Signed-off-by: William Breathitt Gray <wbg@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/counter/counter-core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/counter/counter-core.c
+++ b/drivers/counter/counter-core.c
@@ -124,7 +124,8 @@ struct counter_device *counter_alloc(siz
 
 err_dev_set_name:
 
-	counter_chrdev_remove(counter);
+	put_device(dev);
+	return NULL;
 err_chrdev_add:
 
 	ida_free(&counter_ida, dev->id);


