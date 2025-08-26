Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC06732144B;
	Tue, 26 Aug 2025 11:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207959; cv=none; b=svAuTYhPEpO8mJp/nh67R1Igyfqn8kkSe0i3LfraWEiRlk1tsal6HpySnN9rwUliWWOCAEG+MPdR5XvUxs7DqFRWrrnEgSsJ38JSyf3QeLidUN1RS1y+ghQdfITMuY7R6nyeV3DOsX5NI/O4nvNMcF3OGiLFqNlkGbllzxJIczs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207959; c=relaxed/simple;
	bh=EsIEF7sA6l0MGnJFV9ECiExtaeORaF91/VRUI7lEAxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gdgWpmN0m13V5OiUyWKCHRQRhUOEBfKUDM0kuUVhZ+uWoRkvlFNRwdL7R8F1x1Ed7lhR0OQZKndZq5PoEQR6x18k76ChCWxzqMVbIiJ/nQ0p7rxMsvP+p/vapicR4g85Ak+tUmmYsV9FKKr7SO9VS4Y9tQ39h4wtMSntOrcXUKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mEaJADUD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mEaJADUD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D83DAC4CEF1;
	Tue, 26 Aug 2025 11:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207956;
	bh=EsIEF7sA6l0MGnJFV9ECiExtaeORaF91/VRUI7lEAxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mEaJADUDeQpBRXCYaNg2EyUmhbT5Duq/bxO6DazMclONzgm8yWH7bvIuH3YUThcjS
	 /Aqnm1jptgiSh72xUt7QAUUHCvBwohiMQ3hei53ZvHBnUmxKuObbeuRxIUqcVfV69a
	 aNzF0JT76eFZVM0sHhVJDm+XrYaKz6+icARJT+jU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitin Gote <nitin.r.gote@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 351/457] iosys-map: Fix undefined behavior in iosys_map_clear()
Date: Tue, 26 Aug 2025 13:10:35 +0200
Message-ID: <20250826110945.997187858@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nitin Gote <nitin.r.gote@intel.com>

[ Upstream commit 5634c8cb298a7146b4e38873473e280b50e27a2c ]

The current iosys_map_clear() implementation reads the potentially
uninitialized 'is_iomem' boolean field to decide which union member
to clear. This causes undefined behavior when called on uninitialized
structures, as 'is_iomem' may contain garbage values like 0xFF.

UBSAN detects this as:
    UBSAN: invalid-load in include/linux/iosys-map.h:267
    load of value 255 is not a valid value for type '_Bool'

Fix by unconditionally clearing the entire structure with memset(),
eliminating the need to read uninitialized data and ensuring all
fields are set to known good values.

Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/14639
Fixes: 01fd30da0474 ("dma-buf: Add struct dma-buf-map for storing struct dma_buf.vaddr_ptr")
Signed-off-by: Nitin Gote <nitin.r.gote@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://lore.kernel.org/r/20250718105051.2709487-1-nitin.r.gote@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/iosys-map.h | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/include/linux/iosys-map.h b/include/linux/iosys-map.h
index 4696abfd311c..3e85afe794c0 100644
--- a/include/linux/iosys-map.h
+++ b/include/linux/iosys-map.h
@@ -264,12 +264,7 @@ static inline bool iosys_map_is_set(const struct iosys_map *map)
  */
 static inline void iosys_map_clear(struct iosys_map *map)
 {
-	if (map->is_iomem) {
-		map->vaddr_iomem = NULL;
-		map->is_iomem = false;
-	} else {
-		map->vaddr = NULL;
-	}
+	memset(map, 0, sizeof(*map));
 }
 
 /**
-- 
2.50.1



