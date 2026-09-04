Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D0C248F64;
	Fri,  4 Sep 2026 05:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501227; cv=none; b=LxhFfUDHNnQKfXUp5jRsNvVfvLSf38eolOWft7NL12gNT88Gan7LrrvR805dV+U2PEjnUItq3LMV9I6cFCTYZKHj5CNM7kt0rRkc4nyEyO+tCtWgTOuMIhWaOKFjizPxMp/YmFfwZVQii9oE+ETkGHoIkYrK4yfvF/TAZ5ZeBEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501227; c=relaxed/simple;
	bh=LLYN619ZNFhsA2oAuzEHSQ8v80p5kufDnS6wC/hAUV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NgIFJAeOFYeEVddWt6g7OGQU68ytxu7OGSm6FdfGyrsNcQXl4yqRVnE99rxCZazXukyilSTkQrIHB2A/LAaEhSDcOdK4JDzsKVStpkxFK8V9aRFCuoSzDbE5VWoKoLH+PWDKOtA9wtoWZHC/KYLbyvfkX4u9pc3Ei3fL4/Mr+OI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MYDiAHpx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MYDiAHpx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFFCF1F00A3D;
	Fri,  4 Sep 2026 05:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501226;
	bh=q4VLHIX+9cKbKZiFx4r3x4VX69A69DS5zshg0LVCNG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MYDiAHpx3kdyTJxVGTsZp6gW+f+tblb1IBEUa8Qzq2FHngVjC4G6VSvWbtbYnCMoq
	 KPKEarYHaR4ra1zK5JeWuo4Q+CtVPudD5J2HjXyKtUB4p9wpufa7R+T5ew0VFf70RB
	 cKFWxolVdj6CflM0ra4iF6nbxn0ypMqCv1LtbXXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Ren Wei <enjou1224z@gmail.com>,
	Mike Marshall <hubcap@omnibond.com>
Subject: [PATCH 6.18 334/552] orangefs: skip leading spaces before parsing client debug masks
Date: Fri,  4 Sep 2026 06:58:11 +0200
Message-ID: <20260904045757.833944007@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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
@@ -569,6 +569,7 @@ static int orangefs_prepare_cdm_array(ch
 		cds_delimiter = strchr(cds_head, '\n');
 		*cds_delimiter = '\0';
 
+		cds_head = skip_spaces(cds_head);
 		keyword_len = strcspn(cds_head, " ");
 
 		cdm_array[i].keyword = kzalloc(keyword_len + 1, GFP_KERNEL);


