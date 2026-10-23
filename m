Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773799;
	b=Vr/IFFEDICYsFfg3wyKy2DtntPvJJ8/0KHwJ6OEWGfurQ9QrK5mGia17cnbhKVDPj5yL
	 uu/ygrjjuO2WW6RIEsVInqeNBw0z72/nez104qKB2UDRyv6TXhYpqH8+NMni1C1Mn4WAS
	 rTC3mn1uiMRAO8JntJCqxNzTPRvOgRZmnhy7fLRnpsGeY5fA5SPFH3JNmZpfQZZ6u6/B7
	 HlVcCJu/mLIf2Jbw5w3Kl9c6d2GLFj1WwKixsdM+932bEsewAaLb1Mfnw//IhgDoXZO3k
	 tYfm0FKd0GcYL+nOEOXVTLadoypZvEGGde7wQQ6FP/FK1jcLYHM6PPXL4zX1vzZTtcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773799;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yXqHMBDzrt22WK+6FlwoaCglb3C+bjTrYk/wCUJ4MWI=;
	b=Bx798/rB9X9tVQt9qu/b44yEDlmT09GESbQqlM0SAMS/U03N9md5yNzeiAQLHipD0wmy
	 y/L6xBFYp6ADdtiz6mvtlvV4k9uUhRg+4lC8PI/ku/njakQIBkatg819x5zeWd4bAql/E
	 tAtbrSnCV1iRwiJ+DM8tsDUP94eFJaohb6M/MBSxdzZkioyd68yxV3W6oKjkZgkCkQdJI
	 yhqWAluUyVhOPvA/+gyFru0zexzMt4gzijGUh7WsvCeF1pFSxlixddNrI8dpntLaLfsK9
	 MyJWTdAj0Vm+375D+hwdOtMaJp9ITXhi7r0jw8IyXY8cKYO3I7VPPV4WQlK8Dsn/ajQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wCezHFVr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC78606A320;
	Fri, 23 Oct 2026 16:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wCezHFVr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41AE71F01825;
	Fri, 23 Oct 2026 16:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773798;
	bh=yXqHMBDzrt22WK+6FlwoaCglb3C+bjTrYk/wCUJ4MWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wCezHFVrBW7QO8IyOovWO3Ups+kXQpYNYC4UVlQBRkrgzyW+45Fq8wGVHqTuQiZx0
	 M4cnSuSLoTePixFWGn/JS8412wJVuJwhcNO9x0N7vWPK7/6nghmTlmEq17ki1qZege
	 q33KJ4o/GipoKY/XcVIe0Ec9VfPg6HGW2DO30M+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 020/193] tools/power turbostat: Fix PMT error path fd handling
Date: Fri, 23 Oct 2026 18:34:57 +0200
Message-ID: <20261023163714.679057107@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Len Brown <len.brown@intel.com>

[ Upstream commit 11741cc90f9176746b8595beab4fec8d736ebd18 ]

It is possible to leak a file descriptor if a diretory
open succeeds, but the scan fails.  Close the fd on error.

Also, on cleanup, check for NULL fd.

Assisted-by: Claude: Claude Sonnet 4.6
Fixes: 4265a86582ea ("tools/power turbostat: Add PMT directory iterator helper")
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index b8ccf277acb23..d7b079d45d365 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -1919,8 +1919,11 @@ const struct dirent *pmt_diriter_begin(struct pmt_diriter_t *iter, const char *p
 			return NULL;
 
 		num_names = scandir(pmt_root_path, &iter->namelist, pmt_telemdir_filter, pmt_telemdir_sort);
-		if (num_names == -1)
+		if (num_names == -1) {
+			closedir(iter->dir);
+			iter->dir = NULL;
 			return NULL;
+		}
 	}
 
 	iter->current_name_idx = 0;
@@ -1948,8 +1951,10 @@ void pmt_diriter_remove(struct pmt_diriter_t *iter)
 	iter->num_names = 0;
 	iter->current_name_idx = 0;
 
-	closedir(iter->dir);
-	iter->dir = NULL;
+	if (iter->dir) {
+		closedir(iter->dir);
+		iter->dir = NULL;
+	}
 }
 
 unsigned int pmt_counter_get_width(const struct pmt_counter *p)
-- 
2.53.0



