Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C401E51FE;
	Mon, 18 Aug 2025 12:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521782; cv=none; b=LduVTsf7F9e5viLhUOEKrFk2sTeTgBncUH9GOHYWH9O9PSWiSSA1e7wWSRn55jK+ST5FbGcaYqZLSOPNd6/qPMPbPWrFWUXr6BBg3RWJR8U3mPna77yw1yLZP2X/1aQNvB9y6Lsj3qJblkt8MY22E0qn9+06RCtHVs9PTEaJ9ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521782; c=relaxed/simple;
	bh=i586I4XE0WushWhzx1G9Crt4ttb0NoHiOFOk4ZtTHx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pL38n9ES14/x2wjqP/9Pc+1u72cGQ2ab00tCfCd6BR2JHN+XLzmQcL7zLasPfN8+inbD8hoj+ml/G2hsRh019rpSegUtyKAge+UfpTkV2a6etrhdwK23FKB40yNdgfTclvXMTC6RUJmPF23RrrscEn3X2RMYi+Vb0ZGmn249DOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C5sK5IXN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C5sK5IXN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF8B5C4CEEB;
	Mon, 18 Aug 2025 12:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521781;
	bh=i586I4XE0WushWhzx1G9Crt4ttb0NoHiOFOk4ZtTHx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C5sK5IXNNmQ+xELa2ZjKbDvqOlXQc7hdV7aOmpAuCxSj6GCmjkGq07R+qf7QuUVyL
	 3IeHJ3qpU3b/Zz0odu5XbNhKm9PuDIvTZKUFX3wFQ3vWMHzScE6gbci7AXhUDsdhfi
	 YwM72vZOrksE8S0sECRsCNfzEkf5UKCptrFZq6pQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Kling <webgeek1234@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 121/444] ARM: tegra: Use I/O memcpy to write to IRAM
Date: Mon, 18 Aug 2025 14:42:27 +0200
Message-ID: <20250818124453.456266972@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Kling <webgeek1234@gmail.com>

[ Upstream commit 398e67e0f5ae04b29bcc9cbf342e339fe9d3f6f1 ]

Kasan crashes the kernel trying to check boundaries when using the
normal memcpy.

Signed-off-by: Aaron Kling <webgeek1234@gmail.com>
Link: https://lore.kernel.org/r/20250522-mach-tegra-kasan-v1-1-419041b8addb@gmail.com
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-tegra/reset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-tegra/reset.c b/arch/arm/mach-tegra/reset.c
index d5c805adf7a8..ea706fac6358 100644
--- a/arch/arm/mach-tegra/reset.c
+++ b/arch/arm/mach-tegra/reset.c
@@ -63,7 +63,7 @@ static void __init tegra_cpu_reset_handler_enable(void)
 	BUG_ON(is_enabled);
 	BUG_ON(tegra_cpu_reset_handler_size > TEGRA_IRAM_RESET_HANDLER_SIZE);
 
-	memcpy(iram_base, (void *)__tegra_cpu_reset_handler_start,
+	memcpy_toio(iram_base, (void *)__tegra_cpu_reset_handler_start,
 			tegra_cpu_reset_handler_size);
 
 	err = call_firmware_op(set_cpu_boot_addr, 0, reset_address);
-- 
2.39.5



