Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43FE720B3E;
	Tue, 23 Apr 2024 21:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908539; cv=none; b=BnOHveeX5xExT4pFhp+ESB1jf6xXWURxBeiOPTWRbnW2q1inGAPjqXv75sU80ClGONlX2vR+1cekAEzPSWlArqBjyJjv3dKP7VvoMvkW3IJIYl4uyPdh3zfXM8iN0qfEVj2qQVSI/Z6GtqJx96DULikWg+kt5KHXLYLaB9UjC24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908539; c=relaxed/simple;
	bh=61z/PE1FBUvYjSff+k+L3f/cEBVNGTPvnEBdNxMgubA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qQ4zqiR1TC7HQAnV3A5hrBspEjy9z90rykjXvt6IE5px4BLcRLhbZf9SUasoFGUyyzgk/CcAwpTKPYYcdihr7Ekl+xE68JKBp8NqazSQMrhjIc6MWMsZCdtJta0+ni6VBXfSOVGhJne5ownDRTQnw0bp8CATsnRQ294VCqChYf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MWRT1LDN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MWRT1LDN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A13C32783;
	Tue, 23 Apr 2024 21:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908539;
	bh=61z/PE1FBUvYjSff+k+L3f/cEBVNGTPvnEBdNxMgubA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MWRT1LDNpl6d73CiHwVUHCnq6b+v7Y3TaoDQZR2MpE6ANmfGNhjL2Nc4vkaAZYg8x
	 ykPnxVo+cjqinA7z32ayc1YUELv315uDNm2zgDkV0ba8cHpPSnV6JE5AuZl/47tnhD
	 L3v+y3mRN+MBYEjhuhrRNKH1i6QJnqF0ikk3Y0N0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuntao Wang <ytcoode@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.8 133/158] init/main.c: Fix potential static_command_line memory overflow
Date: Tue, 23 Apr 2024 14:39:15 -0700
Message-ID: <20240423213900.213251988@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuntao Wang <ytcoode@gmail.com>

commit 46dad3c1e57897ab9228332f03e1c14798d2d3b9 upstream.

We allocate memory of size 'xlen + strlen(boot_command_line) + 1' for
static_command_line, but the strings copied into static_command_line are
extra_command_line and command_line, rather than extra_command_line and
boot_command_line.

When strlen(command_line) > strlen(boot_command_line), static_command_line
will overflow.

This patch just recovers strlen(command_line) which was miss-consolidated
with strlen(boot_command_line) in the commit f5c7310ac73e ("init/main: add
checks for the return value of memblock_alloc*()")

Link: https://lore.kernel.org/all/20240412081733.35925-2-ytcoode@gmail.com/

Fixes: f5c7310ac73e ("init/main: add checks for the return value of memblock_alloc*()")
Cc: stable@vger.kernel.org
Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 init/main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/init/main.c
+++ b/init/main.c
@@ -635,6 +635,8 @@ static void __init setup_command_line(ch
 	if (!saved_command_line)
 		panic("%s: Failed to allocate %zu bytes\n", __func__, len + ilen);
 
+	len = xlen + strlen(command_line) + 1;
+
 	static_command_line = memblock_alloc(len, SMP_CACHE_BYTES);
 	if (!static_command_line)
 		panic("%s: Failed to allocate %zu bytes\n", __func__, len);


