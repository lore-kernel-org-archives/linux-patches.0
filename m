Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1249F35CB6B;
	Mon,  9 Feb 2026 14:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647261; cv=none; b=cwEA9BMKE2zkZX55hIUpb6qa+XSJZIrC6cUeiRfyXV0gN4LxqDePxDiyXOBYntArSmGLBve9yLoXMZmJ3uyjkURWEFDkihLMBoF3pEEAZEQDgTvJhkiuMPH6X5lKvN+nj22TriX5RylC9Bln5IvR0e8Rydp/MZrIupRvupBCurs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647261; c=relaxed/simple;
	bh=Zv5eh7N/PvJoWNh2eo6CP6nnWKORbLttBI9g/cbOBLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BmNQbmX+da5Qva96OUZUwY4SIjpcOL3MAHBOCnZznvLmAyjqvyU1EbVX1Gk3WHtLwomrJAziFsB2Ju1G3lRZazYAql6uyghNAU9Jk50GB3lOkn4y7ebRE4wpQ1R3Y2U0mqomDC/A3EjnEZMNU2mxA3NBOAgyXOsflH66HBan6rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qSpjWmlD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qSpjWmlD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78400C116C6;
	Mon,  9 Feb 2026 14:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647261;
	bh=Zv5eh7N/PvJoWNh2eo6CP6nnWKORbLttBI9g/cbOBLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qSpjWmlDj7TbaeUfC0zDNg/IdOn1ft/WgXxdR8fbXkoZWseWQMi41Zd1iA2KZZHPZ
	 vuC86i7axvSsRf7phdmZdKscSoxBHwaa1/yM+UQzThk9FRgkPgRqe5oDIupcWCyMHm
	 C2xeIfsZ1A7yYRMc80k38nmOHdSemhJ0rnWAQ0+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 6.18 046/175] binderfs: fix ida_alloc_max() upper bound
Date: Mon,  9 Feb 2026 15:21:59 +0100
Message-ID: <20260209142322.128567484@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

From: Carlos Llamas <cmllamas@google.com>

commit ec4ddc90d201d09ef4e4bef8a2c6d9624525ad68 upstream.

The 'max' argument of ida_alloc_max() takes the maximum valid ID and not
the "count". Using an ID of BINDERFS_MAX_MINOR (1 << 20) for dev->minor
would exceed the limits of minor numbers (20-bits). Fix this off-by-one
error by subtracting 1 from the 'max'.

Cc: stable@vger.kernel.org
Fixes: 3ad20fe393b3 ("binder: implement binderfs")
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Link: https://patch.msgid.link/20260127235545.2307876-2-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binderfs.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/android/binderfs.c
+++ b/drivers/android/binderfs.c
@@ -132,8 +132,8 @@ static int binderfs_binder_device_create
 	mutex_lock(&binderfs_minors_mutex);
 	if (++info->device_count <= info->mount_opts.max)
 		minor = ida_alloc_max(&binderfs_minors,
-				      use_reserve ? BINDERFS_MAX_MINOR :
-						    BINDERFS_MAX_MINOR_CAPPED,
+				      use_reserve ? BINDERFS_MAX_MINOR - 1 :
+						    BINDERFS_MAX_MINOR_CAPPED - 1,
 				      GFP_KERNEL);
 	else
 		minor = -ENOSPC;
@@ -424,8 +424,8 @@ static int binderfs_binder_ctl_create(st
 	/* Reserve a new minor number for the new device. */
 	mutex_lock(&binderfs_minors_mutex);
 	minor = ida_alloc_max(&binderfs_minors,
-			      use_reserve ? BINDERFS_MAX_MINOR :
-					    BINDERFS_MAX_MINOR_CAPPED,
+			      use_reserve ? BINDERFS_MAX_MINOR - 1 :
+					    BINDERFS_MAX_MINOR_CAPPED - 1,
 			      GFP_KERNEL);
 	mutex_unlock(&binderfs_minors_mutex);
 	if (minor < 0) {


