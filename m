Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F2A3909A5;
	Sat, 12 Sep 2026 19:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243104; cv=none; b=Sj/ag1VIKzf/U8yJUVCv2h3b+XNbbTdFqJYUoico/wDHenvSlLceUXJnluuamTUIT9ZB+tzGvA4ruquDkrBxc8zFkFPpZ9yavXNDQaAxIx7BdXZtllOuAdzYjjMI54pkL9Zkt9Zgdg3wHf7mz0rh/gOcTuzFZmxyuSykVMQgFrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243104; c=relaxed/simple;
	bh=YwYAK5LN/PRDRYwRrL3PGcBy/50UIDS9uh+8MeX5abc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uaREZSoeaf6F7h3K92um5iNWfPncgMU6rFNlRTL2LUbu+BVEu8Et1J1+9Dx3aLGaRVdmn8eyYdZ1XvqaFYHw+vsspaMRw3EhlZw0xWR6sCKsb7RLwiytIFyxsvFJif8rew+hGDX6+BYeZdW5bDYc0pLHlTiyGSnqrzfqOBcwBEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QVexxhBQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QVexxhBQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 159E21F00893;
	Sat, 12 Sep 2026 19:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243103;
	bh=qV+lqyoKnk9rXCOIJntd6jtOd70UfY/waqeywgMyZdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QVexxhBQ0DN/iV4/8CzOxoAsbElIa7CxGMaCJI6pBL8QBSGKxUU5iciQSIKTFJezT
	 WbTZLfGJyzfblt62BuX0Bxv5xHJpQf7Ft/6d2FT/6DIROaD5StIO3Iq4LfpktvV7Vw
	 2J/CGEJfGITQqWWEy8Iz7jaeULDkc3OXGs6HudVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tanushree Shah <tshah@linux.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 637/798] perf trace-event: Fix buffer overflow in read_string()
Date: Sat, 12 Sep 2026 09:04:25 +0200
Message-ID: <20260912065531.721173377@linuxfoundation.org>
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

From: Tanushree Shah <tshah@linux.ibm.com>

[ Upstream commit 1121a7af1833f8b5723f1e32685b461614353d5d ]

read_string() writes into buf[BUFSIZ] one byte at a time without
checking 'size' against the buffer bound before each write. A
string longer than BUFSIZ in the input overflows the stack buffer.

Add a bounds check before each write to prevent overflow. On
overflow the function returns NULL, matching its other error paths.

Fixes: 9215545e99d8 ("perf: Convert perf tracing data into a tracing_data event")
Signed-off-by: Tanushree Shah <tshah@linux.ibm.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/trace-event-read.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index 8a01af783310a..fd44de3cb873b 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -125,6 +125,11 @@ static char *read_string(void)
 			}
 		}
 
+		if (size >= (int)sizeof(buf) - 1) {
+			pr_debug("string too long (max %zu bytes)", sizeof(buf) - 1);
+			goto out;
+		}
+
 		buf[size++] = c;
 
 		if (!c)
-- 
2.53.0



