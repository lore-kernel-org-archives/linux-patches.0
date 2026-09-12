Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B3347C106;
	Sat, 12 Sep 2026 13:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220438; cv=none; b=h7af8Laif3EFhsmvnfoCN8bERmkRkUyI1RNicNlkvsQkyVR25dcNMOU+NrsDojGi+DHHjuHHPMRxZIVk7kyuOY+y0MfUNdHrbcnMJnnwcVyacgKNenWFUbY+6wt8djYXlSwBI89ia1AmZcP/4pTuUgM3eUsiOV56poxHf1eu/S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220438; c=relaxed/simple;
	bh=JlbLoCVnC6N4glDbjYuzmC1VcSW2/w1C0KFT4sRPjh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jjlxk3r2CaAR2xZSPW82gy/po+7Os6Hm1pU0ucrXuA/+lx01BK+t8jx5e55agRw+Bmr/SW6cyN/WQMO5ajt7L89IIx7XMntLy5efFACa2SWVY+saB58MY6TKCoAg4PMS+m+N3+FaHeydCokQhb/O9OMDAwFVLJadt1VtrRWLfEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KjFGWjVH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KjFGWjVH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B931F000FF;
	Sat, 12 Sep 2026 13:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220437;
	bh=9nLZ2Y0lGtF0tvUT+kP2G8sgpPQq0tieyUFHwlBL6uY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KjFGWjVHF7uNEvJmbkDV98ZR8rD5/tkhHpr9mTFZZiO1DE2NWBCszGQGHR39HeBfX
	 OsmCi7HnkYpTh3VBpspW8LJs+4hsqRR2CIGfaeVOdrPuyTYHFeJB/d69iL/numSnbQ
	 D3cR3zir33dPntGgLveAF80ykX0V4qj9Lq77XHfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Ren Wei <enjou1224z@gmail.com>,
	Mike Marshall <hubcap@omnibond.com>
Subject: [PATCH 6.6 0178/1424] orangefs: skip leading spaces before parsing client debug masks
Date: Sat, 12 Sep 2026 08:43:30 +0200
Message-ID: <20260912065611.278421937@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiling Zou <zhilinz@nebusec.ai>

commit d410cd5303ec59c7cf23dd61423752ce8e9ecb59 upstream.

orangefs_prepare_cdm_array() sizes each client debug keyword buffer
with strcspn(cds_head, " "), but then parses the keyword with %s. The
%s conversion skips leading whitespace, while strcspn() does not.

If a client debug entry starts with a space, the allocation can be sized
for an empty keyword while sscanf() copies the following non-empty token.
This can write past the end of the allocated keyword buffer.

Skip leading spaces before computing the keyword length so the allocation
matches the string parsed by sscanf().

Fixes: f7be4ee07fb7 ("Orangefs: kernel client part 4")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: Codex:gpt-5.4
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Signed-off-by: Ren Wei <enjou1224z@gmail.com>
Signed-off-by: Mike Marshall <hubcap@omnibond.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/orangefs/orangefs-debugfs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/orangefs/orangefs-debugfs.c
+++ b/fs/orangefs/orangefs-debugfs.c
@@ -529,6 +529,7 @@ static int orangefs_prepare_cdm_array(ch
 		cds_delimiter = strchr(cds_head, '\n');
 		*cds_delimiter = '\0';
 
+		cds_head = skip_spaces(cds_head);
 		keyword_len = strcspn(cds_head, " ");
 
 		cdm_array[i].keyword = kzalloc(keyword_len + 1, GFP_KERNEL);


