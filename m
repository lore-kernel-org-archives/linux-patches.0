Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C936B143C6C;
	Tue, 23 Apr 2024 21:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908803; cv=none; b=a/I5m+CN+cd3Nyx1VyoafSuvukJP+ScxnrVPxrk1mK/69zcx1VvY2K+KX80gcYytfuAQ7GPVWLFF+V92PAkUvJdP2wVTtVa2a5qPwZTkBO4+0Q/GN040SaSDGRTIPvfwz83lhZ+CgxIZXlGsmkQYeGB3cQRAYgjPb+a+6oZRRes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908803; c=relaxed/simple;
	bh=EL9Ewr7LiNB4bjcS4u3lQqA8RIY5JHH8issPul0zh1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V/LvNtVwtHSjGIGbULC9xH429Pdz42drrJP8/ik5NTl6AqR7qiFRXHdYk1nzHmE3JoZH96zeBwl60wms1MRSSLt8vI63593Z0V724RWjW+T2Q7BD0DolKD1J/HEh3wef1kvnvi5rT5BckSOe4pgPN453YcnWZ6hq6EM35oNzcWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BDDzIShP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BDDzIShP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E721C3277B;
	Tue, 23 Apr 2024 21:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908803;
	bh=EL9Ewr7LiNB4bjcS4u3lQqA8RIY5JHH8issPul0zh1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BDDzIShPRtoXlnUhzUiwlBm3Vh9NkieH2lCOaBPVQ5u8JvS64P1ZFfFvCqVR9wxK4
	 +bsMCFeSD1tMvKq719n7ZiS+SMU/CAfDPSm+aHJxUKWNrnVPkMzrsimnuNs/RHDSMx
	 BN+Gfi0A6NMnad1dDWfyrASYt0fV5oLcuf1NvXqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuntao Wang <ytcoode@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 5.15 62/71] init/main.c: Fix potential static_command_line memory overflow
Date: Tue, 23 Apr 2024 14:40:15 -0700
Message-ID: <20240423213846.323672207@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213844.122920086@linuxfoundation.org>
References: <20240423213844.122920086@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -640,6 +640,8 @@ static void __init setup_command_line(ch
 	if (!saved_command_line)
 		panic("%s: Failed to allocate %zu bytes\n", __func__, len + ilen);
 
+	len = xlen + strlen(command_line) + 1;
+
 	static_command_line = memblock_alloc(len, SMP_CACHE_BYTES);
 	if (!static_command_line)
 		panic("%s: Failed to allocate %zu bytes\n", __func__, len);


