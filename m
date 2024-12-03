Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73EA6153800;
	Tue,  3 Dec 2024 16:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241784; cv=none; b=RAz8kk63w79xIQth1muKQnycBGn8xaoUPAeJsw1rQ7+lpKTyXL43jf6v6y6tbxT6knbQFDBS7RVeSYls4lZ6/hYUZtz8rDR/yk4R3kdHuPs/xwMCKhmAOx4Nb+DtAESnX6IbhIJRAfc1WNTowNxqg23p4rah2UrbLj05SVkFHag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241784; c=relaxed/simple;
	bh=s+0ALGAJyGrJ9j/UVPDhLnlNsvzF7UAQ890V+BCYNMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OZnkoldZJLBfjO08l8umHhyOGs2A0kf72ca5zDRqv5sgbJxCOJjE2guYc8q82Vzx5PZczSX83BE+u4qax6LwPHb+jk8LjbgedBlhOFLsnx/iFd5tA8MQeuEl/98NAVLbswhzNirYd6DzMcyCaGwN8vO77H68Eoh1Oh82AgKcvV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=te70fgD4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="te70fgD4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5E19C4CECF;
	Tue,  3 Dec 2024 16:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241784;
	bh=s+0ALGAJyGrJ9j/UVPDhLnlNsvzF7UAQ890V+BCYNMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=te70fgD4lBMgoBzxSyucLp2299UhSwreuo9X2sq27JzJ1dL2kHL7vd/bhMAUyJJ7E
	 4TurvBniXT1LDi3CGfH9WZjwugE/iaPS0KINZJPvFOWlp6aSDWNvqGS8izEVuzgpJH
	 40/PdF/0kQnu5UAWBpbM8fZ94GwI1SHQTRamORcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Veronika Molnarova <vmolnaro@redhat.com>,
	Michael Petlan <mpetlan@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 484/826] perf dso: Fix symtab_type for kmod compression
Date: Tue,  3 Dec 2024 15:43:31 +0100
Message-ID: <20241203144802.640461031@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Veronika Molnarova <vmolnaro@redhat.com>

[ Upstream commit 05a62936e6b14c005db3b0c9c7d8b93d825dd9ca ]

During the rework of the dso structure in patch ee756ef7491eafd an
increment was forgotten for the symtab_type in case the data for
the kernel module are compressed. This affects the probing of the
kernel modules, which fails if the data are not already cached.

Increment the value of the symtab_type to its compressed variant so the
data could be recovered successfully.

Fixes: ee756ef7491eafd7 ("perf dso: Add reference count checking and accessor functions")
Signed-off-by: Veronika Molnarova <vmolnaro@redhat.com>
Acked-by: Michael Petlan <mpetlan@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Michael Petlan <mpetlan@redhat.com>
Link: https://lore.kernel.org/r/20241010144836.16424-1-vmolnaro@redhat.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/machine.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index fad227b625d15..4f0ac998b0ccf 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1343,7 +1343,7 @@ static int maps__set_module_path(struct maps *maps, const char *path, struct kmo
 	 * we need to update the symtab_type if needed.
 	 */
 	if (m->comp && is_kmod_dso(dso)) {
-		dso__set_symtab_type(dso, dso__symtab_type(dso));
+		dso__set_symtab_type(dso, dso__symtab_type(dso)+1);
 		dso__set_comp(dso, m->comp);
 	}
 	map__put(map);
-- 
2.43.0



