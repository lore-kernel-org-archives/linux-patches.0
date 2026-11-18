Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022079;
	b=Dy1JS9h79lw+5MQwsgB1QtxC6azWB80W/R2pvbLLDxkZu6hLoX49PaDmpB5oAbpvaN2/
	 lZchOctH4bJjZtNIkuMKAdzFcd560zD8jksbcISQKdYz48Oxx8xULBIL+EbtTdWufJDV6
	 0vGeGt7+rXJZUzcna4QJMBsE+cYReChYwdGq67eXzM/IPqV5izMJd+wpQ+nsGg0wTH6CA
	 wZurvko06sJgvxy7fBUTOG2Kwx5V1VP2ScLXYxBA4eMNP4CgwmOR5pqmV7ZX04Fjltk9K
	 15gvlvDfIdpwdwO4A3B3wgeZkgbdolG5BGPaF64F2bZDvOFqMhgJnrjWq+WuE8QIZfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022079;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+RGYfmGWuvNOoCiYuGSxvCYbGgEjXNYxTwbThD4MZmk=;
	b=gfR874JNLwkx+4dDyt821RfEMXJA+0XfE5N/GowiWxM1TLF4C31TYVY9i1uBFsmd2Vln
	 amzBjmaLXIJ+eVrBUAe0KKo/MfeCgezEyCqOI12tzOW2Rm3mFUGI2gei65eN5kYIx2JQa
	 PpqhMy/U0rXWu4v1hsjVWMK2ZmMfy4XAQex/kMCZmGlr2aAszTAe/sLwszWxqCEwrPgGL
	 ZlK7lIA0cMiwcXlSE+RYmLOPTMgISey4zvN8B2KcPxA+/O99KdrzZxJHZ+U/ZWdDlof8T
	 55vFo9iSXTF1Rd88CPg0PsCRe/wsMESLPlxyW54HDaUxnaCB0itJzrslGJFjbbHyIxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tWRqt3jP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44766606A32A;
	Wed, 18 Nov 2026 17:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tWRqt3jP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95DDC1F000C4;
	Wed, 18 Nov 2026 17:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022079;
	bh=+RGYfmGWuvNOoCiYuGSxvCYbGgEjXNYxTwbThD4MZmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tWRqt3jPEwVI4lFi2rEtNMsgN9BEvYS0ZrC6gdU383e5e8cE1P0iZOyeSd5tFSZO6
	 01nQ9Xy8bBC7TBVX3bZ49xn5bDoTcpNXlMCVr/job6inOwlJFHKVegc/pITiOsSTJW
	 rMNKbn90O27hw3MQPgEbnzRAcjfK+nYBMi5DEF4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naveen Kumar Chaudhary <naveen.osdev@gmail.com>,
	Douglas Anderson <dianders@chromium.org>,
	Daniel Thompson <daniel@riscstar.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2532/2651] kdb: fix memory leak in kdb_setenv() when environment is full
Date: Wed, 18 Nov 2026 16:02:52 +0100
Message-ID: <20261118150415.768121108@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naveen Kumar Chaudhary <naveen.osdev@gmail.com>

[ Upstream commit 22d59ccad2935b7dea7f818793b739343de433a8 ]

When kdb_setenv() fails to find a free slot in __env[], the function
returns KDB_ENVFULL without freeing the previously allocated string
buffer 'ep', leaking memory on every failed call.

Add the missing kfree(ep) before returning KDB_ENVFULL.

Fixes: a30d4ff8193e ("kdb: remove usage of static environment buffer")
Signed-off-by: Naveen Kumar Chaudhary <naveen.osdev@gmail.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/mbwhul34esbxkdbmlbjaquv5lgyzznn6pdapohry3lsiidbz6n@zucvm5os363q
Signed-off-by: Daniel Thompson <daniel@riscstar.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/debug/kdb/kdb_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index ddce56b47b25a..31abaea5454e6 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -338,6 +338,7 @@ static int kdb_setenv(const char *var, const char *val)
 		}
 	}
 
+	kfree(ep);
 	return KDB_ENVFULL;
 }
 
-- 
2.53.0



