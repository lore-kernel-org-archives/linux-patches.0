Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C7026ED41;
	Mon, 13 Apr 2026 16:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098853; cv=none; b=Ij8zUJpaNnBAZ84Hq60iOur45hy7q21y7dIRjRVpPaJ6ffY5N0cXDTI8BwWHfdPg3BabKnEvDWjOIu0djLumjgfVqBMv/z4h4aCl3g33nDU1qtTR22EYgb0YELMFozsgs54Q4B5MfyUs5/bRk/oOd/NeIea6pMjk9HP4j6Xy6kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098853; c=relaxed/simple;
	bh=u5m6dJl+XhynAXeE838a8L4SJM7PlxcHnCFyBqShD54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PIROFniZ50Yj2ND2KshYayVNk5LbHaPyla0ZOjBjttoEe+LNKbnAe4bo8Ksmt9M8bgmMhJh2NIsIc3vHYHDvDs3N4x76yFIhBV8FEsasL+7/VDZgG8JHNavonjAq812G7Ssau6hDvOlndxYoT/q/AscZUP+dNP11HyZXbM0MlQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VgMWdhnf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VgMWdhnf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68DE0C2BCAF;
	Mon, 13 Apr 2026 16:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098853;
	bh=u5m6dJl+XhynAXeE838a8L4SJM7PlxcHnCFyBqShD54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VgMWdhnfg9CE0hAyAzM51WIME8lkdbcZwqvplecGPKH4qLBvfIAeFWas8cuO5c3oP
	 qLmyuleTiiP9KZUPOdKfRFQYKHLE54UgbNis/lNhJXPAzQ4qccBggE1GMDHQH6QQ5n
	 19RBjbtyuJW9BoOBHrjTNBYr91mez4noC1YI4I84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ariel Silver <arielsilver77@gmail.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.10 115/491] media: dvb-net: fix OOB access in ULE extension header tables
Date: Mon, 13 Apr 2026 17:56:00 +0200
Message-ID: <20260413155823.346897338@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


