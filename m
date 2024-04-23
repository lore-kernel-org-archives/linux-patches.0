Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE2F20B3E;
	Tue, 23 Apr 2024 21:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908484; cv=none; b=Zki5UElw+Cs1BZVg3N9q1yH/HLNC7n5mPR86lW80p1N8F/JeRpuQRiPEVjjwU0Af24Y7hIarHDbPV+zDjbkkJ0ho+s9CfMWkuHne8pI0s4f3nTB40Gj0jSwI3IgtsQhztcCOvqEdvxj0UwYog4v6j6ZMSKOAcMaMVG5UumWlDN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908484; c=relaxed/simple;
	bh=fD3Ro56gEYjetf67xso6knueKLse6Jpak9UT6/NIKEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pycoQ03SmZc5g1PE6DQRaxbXSdD8eHgZ+gnKVDZKImOch7och6zjbEDl6Rj8G4H3zkDnWs/pqLM4a58MSzuykZQQRs/t4/Oe7M0NGfn7J7I+nOzWnXPOl55mYRLiJAnYzxATm5EwGA7iU/agH0VB0NcZIwy8OSFBcL0XX+zoXPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bvChE/Dy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bvChE/Dy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41018C32782;
	Tue, 23 Apr 2024 21:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908484;
	bh=fD3Ro56gEYjetf67xso6knueKLse6Jpak9UT6/NIKEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bvChE/DyS0ah8Nq3zRA91A00pb3Lc9/+MhDOouJZMmy/I2ymE4oJ1EzZO2+IhuI0f
	 JPexbePFwdXHgT9KwSbqruWom8IFsSHwpvIeLkME1BWopdMJcbPGMWPnZSbg9Qm/0B
	 0owjM2C9A4K/gZgXeRZFK7V+MJ+laALjlxnzDilM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 032/158] selftests/tcp_ao: Fix fscanf() call for format-security
Date: Tue, 23 Apr 2024 14:37:34 -0700
Message-ID: <20240423213856.931300791@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Safonov <0x7f454c46@gmail.com>

[ Upstream commit beb78cd1329d039d73487ca05633d1b92e1ab2ea ]

On my new laptop with packages from nixos-unstable, gcc 12.3.0 produces:
> lib/proc.c: In function ‘netstat_read_type’:
> lib/proc.c:89:9: error: format not a string literal and no format arguments [-Werror=format-security]
>    89 |         if (fscanf(fnetstat, type->header_name) == EOF)
>       |         ^~
> cc1: some warnings being treated as errors

Here the selftests lib parses header name, while expectes non-space word
ending with a column.

Fixes: cfbab37b3da0 ("selftests/net: Add TCP-AO library")
Signed-off-by: Dmitry Safonov <0x7f454c46@gmail.com>
Reported-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/tcp_ao/lib/proc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/tcp_ao/lib/proc.c b/tools/testing/selftests/net/tcp_ao/lib/proc.c
index 2fb6dd8adba69..8b984fa042869 100644
--- a/tools/testing/selftests/net/tcp_ao/lib/proc.c
+++ b/tools/testing/selftests/net/tcp_ao/lib/proc.c
@@ -86,7 +86,7 @@ static void netstat_read_type(FILE *fnetstat, struct netstat **dest, char *line)
 
 	pos = strchr(line, ' ') + 1;
 
-	if (fscanf(fnetstat, type->header_name) == EOF)
+	if (fscanf(fnetstat, "%[^ :]", type->header_name) == EOF)
 		test_error("fscanf(%s)", type->header_name);
 	if (fread(&tmp, 1, 1, fnetstat) != 1 || tmp != ':')
 		test_error("Unexpected netstat format (%c)", tmp);
-- 
2.43.0



