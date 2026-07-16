Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C832C41F7CC;
	Thu, 16 Jul 2026 14:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211199; cv=none; b=ocQuIQafdj4G8QgPH4FBhRLjIKgrEcHIHglQH+PyEVIVXAl1vw8YyF4VNtU+tJjtO9M6DfbUOdP0uqktk2OnIEIEylmMhf1RnF6BfG55lhGMTaO0ffWGtX7ujI84lkj3cNijlRAEkimFJp9kvCQS0L7W3sX6j6ZVi0bERr0Z0RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211199; c=relaxed/simple;
	bh=y5DMFO69t3bdAK5uTepj3d7InpCeBJbH9kOzuvjjK8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KFOEv1cRLCEGlEPU0KE5cwpOVYvNSvBWKoT1NAJlmKHH0fS0gWjTd82pBw38eOmtCNfV72O+DYYLMSYvdY6z+47Pl4TmSvzmAFgP573263kH/e7C4bipLbBGWWSvxwyLUano/I8YlDFyRpi1Ov5lGz0wYSYN7Ngbh3FyqOwPubA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S6k146wv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S6k146wv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C961F000E9;
	Thu, 16 Jul 2026 14:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211198;
	bh=sqaZ9j4myfEAFeE5qT4OAiSDNh/nUHgw1QX5Xg4KAHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S6k146wv48hmiwXM7qyvIzFpBUW3+Hck8ru3szVupKb4Lu2YHSh4q0Y9V4efA/5qA
	 felGYY5gchEOtVbj0cIyiocTbeE8wT8Jkphh4Eb9a/PZrrDz5TIA5e3LRu3CLv122m
	 t2kBnQKVEpXAFWTeG5qWDhAhEFX9JBcNwv1sKxqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 6.18 338/480] dm-ioctl: report an error if a device has no table
Date: Thu, 16 Jul 2026 15:31:25 +0200
Message-ID: <20260716133052.123560547@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 457e32348d606a77f9b20e25e989734189834c07 upstream.

When we send a message to a device that has no table, the return code was
not set. The code would return "2", which is not considered a valid return value.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-ioctl.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1806,8 +1806,11 @@ static int target_message(struct file *f
 		goto out_argv;
 
 	table = dm_get_live_table(md, &srcu_idx);
-	if (!table)
+	if (!table) {
+		DMERR("The device has no table.");
+		r = -EINVAL;
 		goto out_table;
+	}
 
 	if (dm_deleting_md(md)) {
 		r = -ENXIO;


