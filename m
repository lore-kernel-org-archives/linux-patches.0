Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E8D399CE9;
	Fri,  9 Oct 2026 14:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555837; cv=none; b=NlmdNEOLAsH56pO+DV1cJpZqhO5QTgZkLYG22fgrt1vXBzU9PUcfrukDF+4IyzANWhAx1mAiAuLxf48sF7FV8La36s4xe9a82duExU3xGJZ8+UiD8WrP0ewhffzwTIs52qGxRFtrokOGd9bbABc+YAGxe9+t5Xk3YN3lcHxgmmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555837; c=relaxed/simple;
	bh=PQVt3QiL11Me3gCb0ZLWNe55zjbEME2iAJE56dGgVps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R8B1+iqdLlXLCVvgw8wrGcTTIm5uiY+jhJffK0LtE2PnTt7tWr6oPgwmXgSCtk3eJhWTbUzBuA2QVgP5qhz2avd+vzIBjWzAoB/38MMWTHZTU4GzMnPpTMnZTlglOXUPqNMBotdfPix/7FDXzSKs+nPYGJgJ5wZJZLjODhsmFqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I6Iyo9Ey; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I6Iyo9Ey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2068A1F000FF;
	Fri,  9 Oct 2026 14:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555836;
	bh=TMKsiQOkeVRmazbe1oIKtaEzwXAYycyIo8NqmEnYH1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I6Iyo9EyoNfwFfDHMxVVXKVoLSEQ7T20guZxeHlkbmqrD5+J5GIUMtWU/LBp+DVY8
	 xWbbqqsDBPIW2rrltEUv3+F6ShRI7Eq5bW0bGtqLjMW25Nwc8agzTr/nI4Phjwh0M5
	 O/CvwhBVLCp9lLD7C/ICRyIRFADunStJ5AIC/Q/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <oss.patchbox@gmail.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 126/403] of: Put coreboot node after compatibility check
Date: Fri,  9 Oct 2026 16:08:07 +0200
Message-ID: <20261009140955.024372511@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <oss.patchbox@gmail.com>

[ Upstream commit 77f21a59e8cf7efcc1c4b3e9176e8b99993a7ae4 ]

of_find_compatible_node() returns a referenced device node, but
EXCLUDED_DEFAULT_CELLS_PLATFORMS used the result only as a boolean and
discarded the reference. This leaked a reference each time the
address-cells or size-cells warning condition was evaluated on a
coreboot system.

Use a helper that checks for the coreboot node with a scoped reference,
so the reference is dropped once the check is done.

Fixes: 8600058ba28a7 ("of: Add coreboot firmware to excluded default cells list")
Signed-off-by: Yuho Choi <oss.patchbox@gmail.com>
Link: https://patch.msgid.link/20260924011358.734722-1-oss.patchbox@gmail.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/base.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index ffd1d51dff38b..1fed97aeafeda 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -95,9 +95,17 @@ static bool __of_node_is_type(const struct device_node *np, const char *type)
 	return !strcmp(match, type);
 }
 
+static bool of_coreboot_present(void)
+{
+	struct device_node *np __free(device_node) =
+		of_find_compatible_node(NULL, NULL, "coreboot");
+
+	return np;
+}
+
 #define EXCLUDED_DEFAULT_CELLS_PLATFORMS ( \
 	IS_ENABLED(CONFIG_SPARC) || \
-	of_find_compatible_node(NULL, NULL, "coreboot") \
+	of_coreboot_present() \
 )
 
 int of_bus_n_addr_cells(struct device_node *np)
-- 
2.53.0



