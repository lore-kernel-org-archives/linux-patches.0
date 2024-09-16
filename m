Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB3B149C57;
	Mon, 16 Sep 2024 12:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488710; cv=none; b=eT2mHWn/CZjBdvrbwYhQjECdYl7p+WV5bVz2h9CZTHAkQyYYdgzD7MuVNe3onl+6y4Rr6O1Lw1XN69iJX4IhYwxy4CaYw4/mTV3EX5imiWuokhAdilX5hM8zZTjERWo/ghN0M6IsL5RnpLddpX+1v74tIFa2GO2M6RgQddQhNOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488710; c=relaxed/simple;
	bh=K8hjQ1OsUhWU7+H1Uf7rXYAbknhjlIDonlUNfzyEFrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CRq8CdXz7g75jmcI8on4wltUAyOoVBgkopUJ4HRI3HXgkrgvv7/SF6DEULErA9WWs3HyT3AjOelcwdeULmh+J2efIgljOObNrVNvsX03DrCL8fx+ABKBzBLEJBlq4vHDasd+1mwDGGTisQBSq1HEmr0PWw8N4Omxzbcses8v6ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D6riA+Zu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D6riA+Zu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B2FC4CEC7;
	Mon, 16 Sep 2024 12:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488709;
	bh=K8hjQ1OsUhWU7+H1Uf7rXYAbknhjlIDonlUNfzyEFrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D6riA+ZuuzWl5HqcolaqXs+ed/np6Khbsle06xod3nbwI74s4UIC/tPikKuItHsZC
	 GDM/mUSCuNkt8q1oXBL2/vrCy7zEpCmx9eDaMSKrLx94CzhA6YSc/J5ChdIdG/wxR7
	 b+rH6If1oxFdTgn1ofjAjkpat9v1KeGtRI4V3TL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 87/91] ASoC: codecs: avoid possible garbage value in peb2466_reg_read()
Date: Mon, 16 Sep 2024 13:45:03 +0200
Message-ID: <20240916114227.316773581@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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

From: Su Hui <suhui@nfschina.com>

[ Upstream commit 38cc0334baabc5baf08a1db753de521e016c0432 ]

Clang static checker (scan-build) warning:
sound/soc/codecs/peb2466.c:232:8:
Assigned value is garbage or undefined [core.uninitialized.Assign]
  232 |                 *val = tmp;
      |                      ^ ~~~

When peb2466_read_byte() fails, 'tmp' will have a garbage value.
Add a judgemnet to avoid this problem.

Fixes: 227f609c7c0e ("ASoC: codecs: Add support for the Infineon PEB2466 codec")
Signed-off-by: Su Hui <suhui@nfschina.com>
Link: https://patch.msgid.link/20240911115448.277828-1-suhui@nfschina.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/peb2466.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/peb2466.c b/sound/soc/codecs/peb2466.c
index 5dec69be0acb..06c83d2042f3 100644
--- a/sound/soc/codecs/peb2466.c
+++ b/sound/soc/codecs/peb2466.c
@@ -229,7 +229,8 @@ static int peb2466_reg_read(void *context, unsigned int reg, unsigned int *val)
 	case PEB2466_CMD_XOP:
 	case PEB2466_CMD_SOP:
 		ret = peb2466_read_byte(peb2466, reg, &tmp);
-		*val = tmp;
+		if (!ret)
+			*val = tmp;
 		break;
 	default:
 		dev_err(&peb2466->spi->dev, "Not a XOP or SOP command\n");
-- 
2.43.0



