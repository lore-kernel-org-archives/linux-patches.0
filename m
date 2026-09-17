Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A0051FCBB;
	Thu, 17 Sep 2026 15:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658770; cv=none; b=Y0OZwM8UTgzqWpXVNWKWUAEXKcxt0kJCjF4M+50yeFKenQIfvZB/ZxItizIolgUYirAanenFXgdfrmQIaAeI8pCdmxTZ+TdwNDED9GzISheW5hVUVEMMMUPu6jUY60Z0gpemgEdhbL88JW8mGIWqBFcsjbEBNvRDf0ddcCKs9K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658770; c=relaxed/simple;
	bh=2wEK9dtHCcBU5y+/N1g9cctrFiYyoPkNJE6x3SP+W2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lDpnMYMKRjGUt1edWpYCemjAqYpjxcsY/0sp7aMl5mX0YmIqajMH5HKdwOlDD7f9vWFWvKH50F8UmgnyfVrRjSRDYOt6h7Knbm1AMnVuyd7Luv/OZodU+m107JWA0QBkSRSuqvkKegL35e0m3pm5ijSa8PamByJyPrn2AwIiEkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vOBjTKkn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vOBjTKkn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9821F0089B;
	Thu, 17 Sep 2026 15:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658758;
	bh=5+FBqBotE6RV6GZANoCcgdbaXgXZOgoRmkqjkabKIfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vOBjTKkndflxLmhkhZ8Kj7E0LVZE+X07wqoRkgfRz5mVzIIUuJtoqVeM1UPHD/Vpr
	 uIIQtBuWqhG+NTGsHFWX/EBj+KXgKcOt346JCazp5pTTndzTHj3rt8v+4IotI1OSb1
	 r8RTTArG5LVG4219hd9/7fEOgf+5zaSmTOdAazRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Zhen <max.zhen@amd.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 029/733] accel/amdxdna: Remove __counted_by from struct amdxdna_cmd_chain
Date: Thu, 17 Sep 2026 16:05:37 +0100
Message-ID: <20260917151351.448910896@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit b3709d354545e70388177500761f92d906c4dfd6 ]

struct amdxdna_cmd_chain contains a flexible array annotated with
__counted_by(command_count). Since the structure is stored in shared
AMDXDNA_BO_SHARE memory, userspace can modify command_count concurrently.
If command_count is changed to zero, the bounds check generated from
__counted_by may fail and trigger a kernel panic.

Remove __counted_by to avoid relying on the userspace-controlled
command_count for the flexible array bounds check.

Fixes: aac243092b70 ("accel/amdxdna: Add command execution")
Reviewed-by: Max Zhen <max.zhen@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260821033543.1839719-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_ctx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/accel/amdxdna/amdxdna_ctx.h b/drivers/accel/amdxdna/amdxdna_ctx.h
index b6bef3af7dab4..6e78bab8a02c0 100644
--- a/drivers/accel/amdxdna/amdxdna_ctx.h
+++ b/drivers/accel/amdxdna/amdxdna_ctx.h
@@ -55,7 +55,7 @@ struct amdxdna_cmd_chain {
 	u32 submit_index;
 	u32 error_index;
 	u32 reserved[3];
-	u64 data[] __counted_by(command_count);
+	u64 data[];
 };
 
 /*
-- 
2.53.0



