Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502AC14600E;
	Tue, 23 Apr 2024 21:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908665; cv=none; b=RGRBktZgKkE3k3miNP9qN1v6hMUobZSW5ndXelJTFjaoraZoRHzMtN7pIdJ3rwKFBprKwmmRDAhyY3Xg6hTOQXf9xaj4pKCb2FxaVria5SGhe8url3QxHQo+EcDe4YzVM1Fp65YqBs5fUGl4TJDuFMtFDnOaJkvr0ZVw8fL0FBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908665; c=relaxed/simple;
	bh=ECwpEBAbLLwM6geBmzOnetMeDWndm8wa/Se50Km4uXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NSeVoh8O/Z19tw7cGMqfgrvlXDI46MG/IZwMJxO0ylEjIYErMMqYXS/QH0SbEp35DIVV1GoKedDzD6qTcCfPQ615moa9Fserscjh0mk0r1e5jpm1u2Yt16B2YpjyhPrNcWaEyc+uNFGKbe66kYRq2Td8bB2jPPXQr0YKUZWYJz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XjpFnvSk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XjpFnvSk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F53C116B1;
	Tue, 23 Apr 2024 21:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908665;
	bh=ECwpEBAbLLwM6geBmzOnetMeDWndm8wa/Se50Km4uXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XjpFnvSkGJ0MeR8LpGX3OlpX9Nu2R1Afz9PQ/eUz36qajDKXD4QVj4u2F1h+R6OiO
	 +e9XMl9vF9yp15d1Oa9TLtPbdvQh+HUjf4ytAwtVmxjz9VYvWowdu0wOK1gnxDWetA
	 opIyhKqoQC8J98CY+C5xG7M/CzYD2gxdXB51Dqpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuntao Wang <ytcoode@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.6 135/158] init/main.c: Fix potential static_command_line memory overflow
Date: Tue, 23 Apr 2024 14:39:32 -0700
Message-ID: <20240423213900.089152680@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -630,6 +630,8 @@ static void __init setup_command_line(ch
 	if (!saved_command_line)
 		panic("%s: Failed to allocate %zu bytes\n", __func__, len + ilen);
 
+	len = xlen + strlen(command_line) + 1;
+
 	static_command_line = memblock_alloc(len, SMP_CACHE_BYTES);
 	if (!static_command_line)
 		panic("%s: Failed to allocate %zu bytes\n", __func__, len);


