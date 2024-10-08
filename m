Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A541DED69;
	Tue,  8 Oct 2024 12:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389891; cv=none; b=sHehnAMVfzTDMpBlQyFxHiASfbIv/I6otTDtrs0xkOwwJbq7gwbM3NmZf5zfvB8E2aXh2y0vD4c//UYmH105ZmuP5AsasWbbG0hlJBGOwkHbv4uHbmV2hdCJmXLiux5UtzhwUA0pZ0Ogv8aXNdjBGPwRQaiUE6D8iM3uR6jYpw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389891; c=relaxed/simple;
	bh=mCBq7YvJEiQTUfft5nWc7d/Fc+6yoYU34Q22btkxiNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CMF77oMb6g1sW8HSkARI2K4/LBxedz2VrhRMN/tkKvRoKIjaEp/E7lvY0iDI94leLspRFl4uHMw9cQsvaPfCgygYvngZayYjpF9etE4IpKXvOOg0hAjhwtTB0GMT7UwoLW+gZCfzWfrEoSPruU/hhdIasDdPf8vxyIMinF9VtPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oxuMowzR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oxuMowzR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29116C4CECE;
	Tue,  8 Oct 2024 12:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389891;
	bh=mCBq7YvJEiQTUfft5nWc7d/Fc+6yoYU34Q22btkxiNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oxuMowzRZJ/5lYMpQUTx5bXMwfyR59R8WrYN9lI3adOCtXvYxQbOANHM1A4lzbHJ+
	 csFezmPROIf1/wDJ9RChBfmfbxzJ5mq8e/01kK4BlnP381qsQqJ8kvRYFm6YeQfaGQ
	 XEcGdSsAio52vL00MN61dVGDQWJaMRERmSHHupyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 086/482] ACPICA: Fix memory leak if acpi_ps_get_next_namepath() fails
Date: Tue,  8 Oct 2024 14:02:29 +0200
Message-ID: <20241008115651.690492350@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 5accb265f7a1b23e52b0ec42313d1e12895552f4 ]

ACPICA commit 2802af722bbde7bf1a7ac68df68e179e2555d361

If acpi_ps_get_next_namepath() fails, the previously allocated
union acpi_parse_object needs to be freed before returning the
status code.

The issue was first being reported on the Linux ACPI mailing list:

Link: https://lore.kernel.org/linux-acpi/56f94776-484f-48c0-8855-dba8e6a7793b@yandex.ru/T/
Link: https://github.com/acpica/acpica/commit/2802af72
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/psargs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/acpica/psargs.c b/drivers/acpi/acpica/psargs.c
index 422c074ed2897..7debfd5ce0d86 100644
--- a/drivers/acpi/acpica/psargs.c
+++ b/drivers/acpi/acpica/psargs.c
@@ -820,6 +820,10 @@ acpi_ps_get_next_arg(struct acpi_walk_state *walk_state,
 			    acpi_ps_get_next_namepath(walk_state, parser_state,
 						      arg,
 						      ACPI_NOT_METHOD_CALL);
+			if (ACPI_FAILURE(status)) {
+				acpi_ps_free_op(arg);
+				return_ACPI_STATUS(status);
+			}
 		} else {
 			/* Single complex argument, nothing returned */
 
@@ -854,6 +858,10 @@ acpi_ps_get_next_arg(struct acpi_walk_state *walk_state,
 			    acpi_ps_get_next_namepath(walk_state, parser_state,
 						      arg,
 						      ACPI_POSSIBLE_METHOD_CALL);
+			if (ACPI_FAILURE(status)) {
+				acpi_ps_free_op(arg);
+				return_ACPI_STATUS(status);
+			}
 
 			if (arg->common.aml_opcode == AML_INT_METHODCALL_OP) {
 
-- 
2.43.0



