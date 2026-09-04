Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08337423A85;
	Fri,  4 Sep 2026 06:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502532; cv=none; b=F1VKTTsT1a17WrQaRui3r8To9oJ11tmlrwE8VPpqtfHfC5AVDbvFS+k0jyOqa31EBrow8w2OfVBLMU+YdNC4943JH5x/FbmNMQblQTQIC5DEvJuELZyO93s5h20t/7LBqgDBUdbsTNOxHgAzx1Yten83EQKnyARn3JFeB8WVIHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502532; c=relaxed/simple;
	bh=F4G+d7VapfEIMCsWkqR9IHQ+dusJad1cPZ9ZZi0DEvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SKHfyGR3Z4sg2va83gTjnVqdwUqmtxuvTSP1V/CkeD3KZCfDAVNVPA4GyBBa4kn7IUI465ZF0+p9eJ/+3njCJeToJUwgKwGxdOBo+8tlxLNb1Ewf3vzV5D158YC5mgRXpQ9xpqMSY5jBiK1vlXZZUjvWvGNZAlkh+q0mDT9onEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eg41uzei; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eg41uzei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 635291F00A3D;
	Fri,  4 Sep 2026 06:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502530;
	bh=sjNX0KHVw60z+qvkI4mPugfYH+PtRoLzytcW1VO+PR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eg41uzeiYWMyTZo0TNDgoCKocBIjZaoGscf4IIzNc6Zg89+gk0cvWG206X4Rf/uHX
	 LxXiExFSnl0x08gZXhQKUZWMEUKPjeL6rPI4Kip9R3xKbLyz0diestXvbkAcVWgEqX
	 /IbcGajgucoS+eECx9gvTqInFZm8pPNCbge3ui6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Ren Wei <enjou1224z@gmail.com>,
	Mike Marshall <hubcap@omnibond.com>
Subject: [PATCH 6.12 241/403] orangefs: skip leading spaces before parsing client debug masks
Date: Fri,  4 Sep 2026 07:00:44 +0200
Message-ID: <20260904045740.351674395@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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


