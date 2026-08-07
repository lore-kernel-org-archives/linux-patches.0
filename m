Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996304749F0;
	Fri,  7 Aug 2026 15:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116875; cv=none; b=s2Qfqk/PAhL5MPWx08ZPArNRrXMojjfxn5I0nwPxXtVosvRHnlgwgEIsWH7CT9oqlBOWzcVjkjyrHVgLeE5Ty352sCQ8d/aPJ7Go31x8NtP4OIjpy8ZdbaHgAYddU/IhL5oX57KjsD+rIK4fo1aZtkpcFId9ZeLEtH4uk7dj9sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116875; c=relaxed/simple;
	bh=zDuKMxl79e2TZpH1OsUEu3pK/s1VW4rx2fdc99AiLcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=do3LQTVAWG3PahqltYYfSFyOgZ/hYYmzmdx2/IgQFkIWsdLrNrLkht82Nr0G0YdgQDaP1StU/3crftYKKXhdItKeury9GMCXAcVyf2/byNf9JxbAcKt81J5diYLpk1FKf+6bmYsJmM7G83PhtSnY9YqXq9m9WDqcIW28hdJn8L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cMnNxNx5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cMnNxNx5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 013811F000E9;
	Fri,  7 Aug 2026 15:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116874;
	bh=NebEIZ/okAEb4M56K+t8QeYMzvzm8tXdh1eMJo/vELw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cMnNxNx5swtrgaOK4r7n+OElKl5VhtR0dtIKUe2Vn7S0qgfzDeEgka2YZfRBbmezo
	 i0CtCn0wWKB/EtP8njeMw9d3wcjT9MwrdttcWTz+DpHRCWB/IlfMBuiU5s6nlzyi88
	 7W9rk2WlOI+5W6zGeolnIjjCueMiDXcBO5oDW7KQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 066/438] ASoC: SDCA: Make UMP message size check more robust
Date: Fri,  7 Aug 2026 16:34:22 +0200
Message-ID: <20260807143429.397439086@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 556d872e7c2a0b570c5b0974813847ef0d0cd637 ]

If message offset was larger than the buffer length the size
check will pass incorrectly. Refactor the check such that it is
more robust to invalid sizes.

Fixes: daab108504be ("ASoC: SDCA: Add UMP buffer helper functions")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Link: https://patch.msgid.link/20260722103500.872714-4-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdca/sdca_ump.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sdca/sdca_ump.c b/sound/soc/sdca/sdca_ump.c
index a86bb28c6d0ad..82a8bf75bbca5 100644
--- a/sound/soc/sdca/sdca_ump.c
+++ b/sound/soc/sdca/sdca_ump.c
@@ -141,7 +141,7 @@ int sdca_ump_read_message(struct device *dev,
 		return ret;
 	}
 
-	if (msg_len > buf_len - msg_offset) {
+	if (msg_offset + msg_len > buf_len) {
 		dev_err(dev, "%s: message too big for UMP buffer: %d\n",
 			entity->label, msg_len);
 		return -EINVAL;
@@ -207,7 +207,7 @@ int sdca_ump_write_message(struct device *dev,
 	buf_len = sdca_range(range, SDCA_MESSAGEOFFSET_BUFFER_LENGTH, 0);
 	ump_mode = sdca_range(range, SDCA_MESSAGEOFFSET_UMP_MODE, 0);
 
-	if (msg_len > buf_len - msg_offset) {
+	if (msg_offset + msg_len > buf_len) {
 		dev_err(dev, "%s: message too big for UMP buffer: %d\n",
 			entity->label, msg_len);
 		return -EINVAL;
-- 
2.53.0



