Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230751D8DF6;
	Thu, 17 Apr 2025 18:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913385; cv=none; b=h4jzpfw+a1+gu3651NppWw8s3j28j67Yyo86CSACQudSXKvE3BKAljfLwR4g1F5fcMqLBOWn6bNSC3WXtndEien8TsNT1KQr2iJ6GGuZeN0nb29UtY9Z5yBunNltvCb6aan7NHtGwZGzdLOk+Rra74fgp7jLWvvG7KUIgUeMsBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913385; c=relaxed/simple;
	bh=KGmwicy5h9yETk1exKxq6/AVpvAl/zLVTCA4i1DMn10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mcf30XXvnvsdTFulYUPDlKNl0c4kU7bYmf5VRFMuDhtdUG8VEYntfurvFhfBqF0wro+7DTxWDnqp4w6dVnqBCuOdW/bqEHu3QpI2hTgPotxI7fhrDu0G/H6oxba1ct5C7kPid1kfEDoPSjh2KONm5ofz00P3fkJnMhATh+3/eiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CRiRORoS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CRiRORoS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA697C4CEE4;
	Thu, 17 Apr 2025 18:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913385;
	bh=KGmwicy5h9yETk1exKxq6/AVpvAl/zLVTCA4i1DMn10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CRiRORoSyReUhyKKiHodsEwvdxy7emS9QGcX8LgtnyiErcWivmfhsjcJSn37SY2i6
	 fGCo9dz1iHYhNzbYd35fDMzv4nSOsVUvevqIbFceqhzsH7ICvCjzRYvgG/Eq76VZIh
	 HeGm4CoQ4aWjwFlPFXo8i1Y73YXG6xWvJ3SRWpIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kris Van Hees <kris.van.hees@oracle.com>,
	Jack Vogel <jack.vogel@oracle.com>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 6.14 321/449] kbuild: exclude .rodata.(cst|str)* when building ranges
Date: Thu, 17 Apr 2025 19:50:09 +0200
Message-ID: <20250417175131.044237460@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kris Van Hees <kris.van.hees@oracle.com>

commit 87bb368d0637c466a8a77433837056f981d01991 upstream.

The .rodata.(cst|str)* sections are often resized during the final
linking and since these sections do not cover actual symbols there is
no need to include them in the modules.builtin.ranges data.

When these sections were included in processing and resizing occurred,
modules were reported with ranges that extended beyond their true end,
causing subsequent symbols (in address order) to be associated with
the wrong module.

Fixes: 5f5e7344322f ("kbuild: generate offset range data for builtin modules")
Cc: stable@vger.kernel.org
Signed-off-by: Kris Van Hees <kris.van.hees@oracle.com>
Reviewed-by: Jack Vogel <jack.vogel@oracle.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/generate_builtin_ranges.awk |    5 +++++
 1 file changed, 5 insertions(+)

--- a/scripts/generate_builtin_ranges.awk
+++ b/scripts/generate_builtin_ranges.awk
@@ -282,6 +282,11 @@ ARGIND == 2 && !anchor && NF == 2 && $1
 # section.
 #
 ARGIND == 2 && sect && NF == 4 && /^ [^ \*]/ && !($1 in sect_addend) {
+	# There are a few sections with constant data (without symbols) that
+	# can get resized during linking, so it is best to ignore them.
+	if ($1 ~ /^\.rodata\.(cst|str)[0-9]/)
+		next;
+
 	if (!($1 in sect_base)) {
 		sect_base[$1] = base;
 


