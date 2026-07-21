Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2291A46F4A3;
	Tue, 21 Jul 2026 18:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659692; cv=none; b=ttXSMJytQn4Zj89uDuMrRV8HHQS3zxWHhi7XNVGCdkXWE2wyqtJevvX5qcvFyo162El5O2TiCJRSk0sf74QO+MMkzPfoMmB9DPYW6xmnPpb2QMcw7zADg+4DNO9lrY8u1zkscYBrwm4RNh+xQ9i+RQrCRTNbY5Yam8pB93WwCLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659692; c=relaxed/simple;
	bh=qd6jKNqTpRmWhmkrcFqjvrHlrAH4e2Pe9f5E4OFatSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H2zefRG4/XnTrK/44p0IzyRqDizjvcGn2JPHtSssYJ2q472qVSAC5BAk2BdUGiXYY7ZS5QpijuHGpOXG8QLB5aQcKbUY1nOBMOEsaTVB+Fm39fEfvYUf2LS1XB1YPp9e/7sDAj5/OrUwrA0TQmpAi3RcAtgMqpje1Vv84TGezlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YglH+fib; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YglH+fib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89BF41F000E9;
	Tue, 21 Jul 2026 18:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659688;
	bh=F7QKHE28bpWrzb+JQnRuvpa4W5vkyALSN2AjOX5Uy/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YglH+fib2d5MqjUeiSskprrdUR6t6dieoLZawu9qAX0Igkieo2cqtLAIxEXF6mL3j
	 QPFUm0oraxEkbJsT4X+JfSQGqeGGePhPRj5Q0Ae+w9Z+QDXznVOMVCUX+hDbb514EM
	 2la5BQKEl2YFruSNbr0ciZLknAYPOicsLiDrc/34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1580/1611] functionfs: dont bother with ffs->ref in ffs_data_{opened,closed}()
Date: Tue, 21 Jul 2026 17:28:16 +0200
Message-ID: <20260721152551.010243563@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit fe47466282a69499ae17a22f064e827badb77078 ]

A reference is held by the superblock (it's dropped in ffs_kill_sb())
and filesystem will not get to ->kill_sb() while there are any opened
files, TYVM...

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Stable-dep-of: 3137b243c939 ("usb: gadget: f_fs: initialize reset_work at allocation time")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_fs.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -2143,7 +2143,6 @@ static void ffs_data_get(struct ffs_data
 
 static void ffs_data_opened(struct ffs_data *ffs)
 {
-	refcount_inc(&ffs->ref);
 	if (atomic_add_return(1, &ffs->opened) == 1 &&
 			ffs->state == FFS_DEACTIVATED) {
 		ffs->state = FFS_CLOSING;
@@ -2168,11 +2167,11 @@ static void ffs_data_put(struct ffs_data
 
 static void ffs_data_closed(struct ffs_data *ffs)
 {
-	struct ffs_epfile *epfiles;
-	unsigned long flags;
-
 	if (atomic_dec_and_test(&ffs->opened)) {
 		if (ffs->no_disconnect) {
+			struct ffs_epfile *epfiles;
+			unsigned long flags;
+
 			ffs->state = FFS_DEACTIVATED;
 			spin_lock_irqsave(&ffs->eps_lock, flags);
 			epfiles = ffs->epfiles;
@@ -2191,7 +2190,6 @@ static void ffs_data_closed(struct ffs_d
 			ffs_data_reset(ffs);
 		}
 	}
-	ffs_data_put(ffs);
 }
 
 static struct ffs_data *ffs_data_new(const char *dev_name)


