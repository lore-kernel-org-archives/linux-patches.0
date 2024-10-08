Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3C81DF756;
	Tue,  8 Oct 2024 12:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390443; cv=none; b=QA8042rqLNOznCrn+HFOoskBPc2ga6xhYWuE+TgS1B4lXxpzt2a/DakHfKiKDixaA0OyH0+QnJSOy2vLmoNj3O0eP3UGrRtPLuDNOZYvm882E9BXQB6JCSrV2RlhVfDp2GxB+M9WILVi2kBB+MYExGWtF9ocdxIkP7Z9l4FzMVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390443; c=relaxed/simple;
	bh=eAmXXCWeNK6vyitEk9YLt4udp+KBflTywJ7G5KZp3vE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=riW01pX0yUPRUb44nVeSLLKuh0N+IqQEnGxvbDhZjOD+6QReuRqNrxZZV4lSKce+AWk2EFcMe2EPwfCy9q6tuDcHNw1CwJJF8KloYO/d+aNFC+NATPslVqUWJfP24wrbDv4MgmQc0gqMWOurqCHEegobIcbMVwKCQU13+kAcnyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fvv21FzU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fvv21FzU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D1EC4CEC7;
	Tue,  8 Oct 2024 12:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390443;
	bh=eAmXXCWeNK6vyitEk9YLt4udp+KBflTywJ7G5KZp3vE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fvv21FzUG76DG+I2P5MYTmBtNdGremObOeWz99AmtriKAzgE9IQijAqW2C4ieMuLT
	 Q9H+D/+VdtsJbv0Y1FSo4Jo39UGy+nmzQB+ocbhW6J9nZemJU64++B55DDj+UDqzq9
	 3WZcOuxqyMLk31BcQLZyExL0GCrDKblafxrWxY2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Burakov <a.burakov@rosalinux.ru>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.10 289/482] platform/x86: x86-android-tablets: Fix use after free on platform_device_register() errors
Date: Tue,  8 Oct 2024 14:05:52 +0200
Message-ID: <20241008115659.651635125@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 2fae3129c0c08e72b1fe93e61fd8fd203252094a upstream.

x86_android_tablet_remove() frees the pdevs[] array, so it should not
be used after calling x86_android_tablet_remove().

When platform_device_register() fails, store the pdevs[x] PTR_ERR() value
into the local ret variable before calling x86_android_tablet_remove()
to avoid using pdevs[] after it has been freed.

Fixes: 5eba0141206e ("platform/x86: x86-android-tablets: Add support for instantiating platform-devs")
Fixes: e2200d3f26da ("platform/x86: x86-android-tablets: Add gpio_keys support to x86_android_tablet_init()")
Cc: stable@vger.kernel.org
Reported-by: Aleksandr Burakov <a.burakov@rosalinux.ru>
Closes: https://lore.kernel.org/platform-driver-x86/20240917120458.7300-1-a.burakov@rosalinux.ru/
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20241005130545.64136-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/x86-android-tablets/core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/platform/x86/x86-android-tablets/core.c
+++ b/drivers/platform/x86/x86-android-tablets/core.c
@@ -390,8 +390,9 @@ static __init int x86_android_tablet_pro
 	for (i = 0; i < pdev_count; i++) {
 		pdevs[i] = platform_device_register_full(&dev_info->pdev_info[i]);
 		if (IS_ERR(pdevs[i])) {
+			ret = PTR_ERR(pdevs[i]);
 			x86_android_tablet_remove(pdev);
-			return PTR_ERR(pdevs[i]);
+			return ret;
 		}
 	}
 
@@ -443,8 +444,9 @@ static __init int x86_android_tablet_pro
 								  PLATFORM_DEVID_AUTO,
 								  &pdata, sizeof(pdata));
 		if (IS_ERR(pdevs[pdev_count])) {
+			ret = PTR_ERR(pdevs[pdev_count]);
 			x86_android_tablet_remove(pdev);
-			return PTR_ERR(pdevs[pdev_count]);
+			return ret;
 		}
 		pdev_count++;
 	}


