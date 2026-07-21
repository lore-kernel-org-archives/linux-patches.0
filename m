Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE1244AB6A;
	Tue, 21 Jul 2026 21:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668833; cv=none; b=qrrEGJmGvJIwK+J8xNkyBbxQWb5a5S35aSbTFD3JZpq1oLPECXQueotGzCLc+MuFnCYYX0SIl3zN0Bw+dJXdE443VWch0uOSj9YjyV6wjR/RLrxWMeCzKLvuo4alf9PpiyU/BDBgb8Q09sgfrWEeYN8Ap+CfCt1SGTAtztbQA0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668833; c=relaxed/simple;
	bh=PjOlQ3LHVKaK8qJqMzrJr3fIDwyXc3WH0mkqlo9OQYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iSBQxOOBXh9I4GfbMFLe6LQlDq0e42ZsjvJrAAmik5JoZhEYS0AqEsDry6BOfTOP/V+ftIXlYpsRx/1SMyoDnaBIymoTMyoVDgZdidvcSurwQ0FTSzxJ9BEEO1mOpQxcGBljhd5rlSoB4FJAQy9gVrf8+OoC7ei6XlBgPpSyOxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=czz4uit7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="czz4uit7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739551F000E9;
	Tue, 21 Jul 2026 21:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668831;
	bh=gClZn3KaOprH/lBWZ2espN9P6jCnobP4NPt9DjoQZsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=czz4uit7ERWEmXg7hUlKJzxkiSZa/VNSyQmsHqhPctH0F92gZ0hgVx6jXrkD82VtB
	 Opzo47NVbWY4clor/qMZ7LPQ7+nSZAlUGP1RqOc/8bmcO0iT85zxBBJ5NzHYne5YxY
	 aSCbelVvKBW4Bhk1gAbiQF8PxGjYzITi+jXSbtNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingjing Deng <micro6947@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0288/1067] kconfig: fix potential NULL pointer dereference in conf_askvalue
Date: Tue, 21 Jul 2026 17:14:49 +0200
Message-ID: <20260721152431.045254991@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 662a5e7c37c285..6c4ff012a05ebd 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -323,9 +323,7 @@ static int conf_askvalue(struct symbol *sym, const char *def)
 	line[1] = 0;
 
 	if (!sym_is_changeable(sym)) {
-		printf("%s\n", def);
-		line[0] = '\n';
-		line[1] = 0;
+		printf("%s\n", def ?: "");
 		return 0;
 	}
 
@@ -333,7 +331,7 @@ static int conf_askvalue(struct symbol *sym, const char *def)
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



