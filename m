Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9D1345EA7;
	Sat, 12 Sep 2026 19:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241324; cv=none; b=kx/Lxvj2qReF8wmJHSOUjN+xweGRPR79WQh8Hp1++jgZH7alAv7GLuVbh1sFP46sB8HOEvq9fECi5QuDeQCZDnJmOCn14yCzQ674kW8qAR8HqVxHruhHhq2ozCmGK8XOifgiIjD1r1vEP9QWwRMxQtFXcRLg+ZXrmcpi+FXyP+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241324; c=relaxed/simple;
	bh=Ef2rUWcT5j/WDDDJpEP8PZV5T4kK5uus6nAvt0hISJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IIzub4Lp5wf4y/TcpZ1vo7WtUyTKPOUGP6B5xt6ewrVy15Ml44nOUUb8/zob9JDSwNM8cT4proKlW5j55+VKLR+Tr0yi81pNntRnA9H5IXvD/Fp/TP5imSOYmXRBjgouWl0PtB/HR//chuWzKMY971P26IWoPvFW5zw8L23yRbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MubSmELE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MubSmELE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338111F000FF;
	Sat, 12 Sep 2026 19:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241323;
	bh=GQqQ/d4vw5abYH6uT+JBlksIMXjTRuIQnj1ImrLAcoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MubSmELET9ePLxBX1GVtWmAF4p/rCiZCfiHgn8LgiV56gHMziIuqxCSV5f2QpBxlz
	 PY7srVjyANBqYnG4XfMDfXW2xIY7jtEgtU1yTM4wc5axVWb23om7kv9kmd1bJmRdgr
	 aFg9uZYREIJ9oFQ3LtfpPE4e7qdZ+deS+U8j1/LY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Ren Wei <enjou1224z@gmail.com>,
	Mike Marshall <hubcap@omnibond.com>
Subject: [PATCH 5.10 113/798] orangefs: skip leading spaces before parsing client debug masks
Date: Sat, 12 Sep 2026 08:55:41 +0200
Message-ID: <20260912065519.555058574@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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


