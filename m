Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46AF836493D;
	Tue, 17 Mar 2026 17:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768173; cv=none; b=prQ8hOOOeFgNbGhgRwZhNAlg7+KhF5zfpC+P8iewE8hnwvUpi3OBjxn/83U2Y2y7S0TFJiTbUrmowByNSDBO/gkWnA72NmGn173eb3fAMQ42uXvZrhWM2clBgQAUDI6xM8CFamP5bGA5PeJaqNYf5wvbb0t15rYCFXMkC+iY5/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768173; c=relaxed/simple;
	bh=6AgH7eB16jnOFyN3cYGVIV6oUpmt2xE/KWEB75Kb5gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cpFeS16bZ8aHi2PP1Uab17oBavtzSFsPlVBVd2Si+lNQo9v/FbpZOVXoqNqOaOL1ojZaWvn+Jru0vu7MSPPRhP85LqqPGOb+h2YLy67Zf+aPFiBbjvrV/1eHjvkTlDeQNpMJq+lQrKtBkT8+5T07nVw/FGJlLHlQn7sLH5AL1po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vKO/nKPT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vKO/nKPT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92631C4CEF7;
	Tue, 17 Mar 2026 17:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768173;
	bh=6AgH7eB16jnOFyN3cYGVIV6oUpmt2xE/KWEB75Kb5gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vKO/nKPTmBkFoE5M9/p2zsI11SM68eFanrWd6/+mX5U+v3AlTlhtk/rnTM7A7PuGL
	 f01XvGmCxGhhQx4YP+BP/mmVl5y6F4AbV+CkcekWrvpAeeGAM3tArVLO35zdTBN/4F
	 e2k0AhjH5I1aGHMULh9NUWfDyyDPKTgBirBhNxZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ariel Silver <arielsilver77@gmail.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.18 215/333] media: dvb-net: fix OOB access in ULE extension header tables
Date: Tue, 17 Mar 2026 17:34:04 +0100
Message-ID: <20260317163007.337311528@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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


