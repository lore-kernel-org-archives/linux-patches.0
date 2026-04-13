Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8853090F5;
	Mon, 13 Apr 2026 16:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097589; cv=none; b=rFkhQZ2slNkDSncbuBCANLhSQ5DtulgUnfQhLINF3Okr5D5TUDJm+c5J9BFjYyejMIa9Fcz1M0G9di6mf8DXzNauXgQ9Bc4sAhlPR/qpqsGxTkCPiGjj/DtS1Y61TcwQyGit6Bqm6QId8RsFFJBg7meqWKDHYsytW21v/uyQrr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097589; c=relaxed/simple;
	bh=8v0vVHbzspQbDoEyGG2zzNZA5uLGzXNWwgopEFTtMAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mbh9Xb+AYlF4g3TFEnopur3m+Ba7TB6i1T1py5RogHO99ttdacsNKYjEzklBYRj6mlhuEruUpYxbVh7E+yKymKo/N/5X1jBxim1ynvI5eoGw7wnWmSYRJ0ESCERwkYWNCMoYXJeUPByFe/fkLxNw3NNQ7Mkp3thdODUqAGkoHnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XVDnejV8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XVDnejV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12E6FC2BCAF;
	Mon, 13 Apr 2026 16:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097589;
	bh=8v0vVHbzspQbDoEyGG2zzNZA5uLGzXNWwgopEFTtMAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XVDnejV8G+LkgekKPVos50XnTEwQWwzdBZPKmGZOFRr9lhwh8Qfwrx+COA/jsPoYs
	 Y0SltM+Rn9bN7eTQErudz17a0ePC5pNfHpmGqo+ZTzoPt8AKByuN2AKtfty4rkonz3
	 GKkoKOaZ/9L2uRjnf9dfnFVdC3ZD9mMUBVbnDR4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ariel Silver <arielsilver77@gmail.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.15 163/570] media: dvb-net: fix OOB access in ULE extension header tables
Date: Mon, 13 Apr 2026 17:54:54 +0200
Message-ID: <20260413155836.556954078@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ariel Silver <arielsilver77@gmail.com>

commit 24d87712727a5017ad142d63940589a36cd25647 upstream.

The ule_mandatory_ext_handlers[] and ule_optional_ext_handlers[] tables
in handle_one_ule_extension() are declared with 255 elements (valid
indices 0-254), but the index htype is derived from network-controlled
data as (ule_sndu_type & 0x00FF), giving a range of 0-255. When
htype equals 255, an out-of-bounds read occurs on the function pointer
table, and the OOB value may be called as a function pointer.

Add a bounds check on htype against the array size before either table
is accessed. Out-of-range values now cause the SNDU to be discarded.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Ariel Silver <arielsilver77@gmail.com>
Signed-off-by: Ariel Silver <arielsilver77@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-core/dvb_net.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/media/dvb-core/dvb_net.c
+++ b/drivers/media/dvb-core/dvb_net.c
@@ -228,6 +228,9 @@ static int handle_one_ule_extension( str
 	unsigned char hlen = (p->ule_sndu_type & 0x0700) >> 8;
 	unsigned char htype = p->ule_sndu_type & 0x00FF;
 
+	if (htype >= ARRAY_SIZE(ule_mandatory_ext_handlers))
+		return -1;
+
 	/* Discriminate mandatory and optional extension headers. */
 	if (hlen == 0) {
 		/* Mandatory extension header */


