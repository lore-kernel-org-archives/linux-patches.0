Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A833037473A;
	Tue, 21 Jul 2026 22:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671470; cv=none; b=X9RLA0eTY5+40vZgUUnB1FCDBVZcTBm+zcJjsc6K5f2kB+yVKrhYHCkshB3NFSbBJXHQHBSuSC1Bv5aqw2JTKHhqN2P0BtbLe1YaRg0W9tRq6i5JEcqZGDtKiiLNmKlHfN34+YAKkQt0g9dlfdgjgUp1FEPqkoy+hlFGnY9OjRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671470; c=relaxed/simple;
	bh=tFUsLJXBleSBsxg4mUkPWF574EAlTe/cMHWx9M4a2Is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IHyMbBUjyJE7m53dOsIMGmwTLTHwycY6QIcAt3Rl0x1CpcTXV8t5QF5r4zgaEa8VB9o81KdklmQdQY8X5SPvZ2B7VLLovEZGzemj9tsk34X1ifa0RamPP/7uuGeMcOW2mz5Iszf1+ttzJUkF0fSvbrv+mi/3eXXFQtcAHINyBc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XKGd826h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XKGd826h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A7631F000E9;
	Tue, 21 Jul 2026 22:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671469;
	bh=s/qOK5dOTZuXR/+15tN7f1fHo7y3QJxiQOfo4+Bv17U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XKGd826hRtZHcpuGmvr8S+uiA8nsD+q0eMHIyh60BjVMGTjcUBufBtXZ2V734ruDT
	 aL1rfN9HdbYns+iBt2ZkUPX8fdZU4YjMw/tGIuHq+BVxScaPBQh0Sv4S2YgoJiT0q7
	 BdU1v/nNGqWdf0/f7bSsI1hSN7nCPkgQGHxalf5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingjing Deng <micro6947@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 221/843] kconfig: fix potential NULL pointer dereference in conf_askvalue
Date: Tue, 21 Jul 2026 17:17:36 +0200
Message-ID: <20260721152410.988072038@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xingjing Deng <micro6947@gmail.com>

[ Upstream commit b9d21c32dca2167a614e66c9e27999b9e1c33d55 ]

In conf_askvalue(), the 'def' argument (retrieved via sym_get_string_value)
can be NULL. While current call sites ensure that 'def' is valid,
calling printf("%s\n", def) is technically undefined behavior and could
lead to a segmentation fault on certain libc implementations if the
function were called with a NULL pointer in the future.

Improve the robustness of conf_askvalue() by providing an empty string
as a fallback.

Additionally, remove the redundant re-initialization of the 'line'
buffer inside the !sym_is_changeable(sym) block, as it is already
properly initialized at the function entry.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xingjing Deng <micro6947@gmail.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Link: https://patch.msgid.link/20260306021709.27068-1-micro6947@gmail.com
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/conf.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index ab1c41eb6d035a..de9fb688c6e6eb 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -326,9 +326,7 @@ static int conf_askvalue(struct symbol *sym, const char *def)
 	line[1] = 0;
 
 	if (!sym_is_changeable(sym)) {
-		printf("%s\n", def);
-		line[0] = '\n';
-		line[1] = 0;
+		printf("%s\n", def ?: "");
 		return 0;
 	}
 
@@ -336,7 +334,7 @@ static int conf_askvalue(struct symbol *sym, const char *def)
 	case oldconfig:
 	case syncconfig:
 		if (sym_has_value(sym)) {
-			printf("%s\n", def);
+			printf("%s\n", def ?: "");
 			return 0;
 		}
 		/* fall through */
-- 
2.53.0



