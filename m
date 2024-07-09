Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8099158A30;
	Tue,  9 Jul 2024 11:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524125; cv=none; b=pHGEmNVT89+8Q4DsFO82mU8WZMOfjhr88rjux1tAI2rluUUxUrDHd3z04YXIqUI4XCOzvGFR1iv3bh9RkWroZ/ZT9yKO1wGAAARy2o/KNyzxIPOdWbw9aMtXiUibV/DrTA1jCZ1zsADaJy0hmMP3Yuz72QlUdrKptWC6f5EcIZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524125; c=relaxed/simple;
	bh=A2/Nc4rRg+QUDA6nm0x/tD/yk3s4v2fcGiOIBJSJI+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L8ypbHXTADsMn78EKk/mcMR3fn2Rt+9bGAqBXhnn3xo+B/HOdJG52mFtnfRctNv6MfMDVjrDhY389s55PtBmrEn6J3OrsRmb5i0tMeobbBtueKdTo7KI7mbbIJ0XvC6amm7pBzxBUGuePVV1qKnDq9R+yzK6xlN+XFcT1XUerKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kjmRKIXX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kjmRKIXX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D337C32786;
	Tue,  9 Jul 2024 11:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524125;
	bh=A2/Nc4rRg+QUDA6nm0x/tD/yk3s4v2fcGiOIBJSJI+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kjmRKIXXhUCUlYTSiDkfhnxGyfRiIj92gw+MxKeTmFSR1iERp7czZDxmxJATiWFY+
	 YZS57X7oJI/9ZGVCL0wo0g0e6D6vFaAQOb6taEmWATvrW6BDm5ku3q2foDswdQ+Tj6
	 u0/7EV5ZQfzow40jXqw6lL9ftCXLwCY0TnLlJwE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 079/197] tools/power turbostat: Remember global max_die_id
Date: Tue,  9 Jul 2024 13:08:53 +0200
Message-ID: <20240709110712.025995101@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Len Brown <len.brown@intel.com>

[ Upstream commit cda203388687aa075db6f8996c3c4549fa518ea8 ]

This is necessary to gracefully handle sparse die_id's.

no functional change

Signed-off-by: Len Brown <len.brown@intel.com>
Stable-dep-of: 3559ea813ad3 ("tools/power turbostat: Avoid possible memory corruption due to sparse topology IDs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 8071a3ef2a2e8..25417c3a47ab6 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -1415,6 +1415,7 @@ struct topo_params {
 	int allowed_cpus;
 	int allowed_cores;
 	int max_cpu_num;
+	int max_die_id;
 	int max_node_num;
 	int nodes_per_pkg;
 	int cores_per_node;
@@ -6967,7 +6968,6 @@ void topology_probe(bool startup)
 	int i;
 	int max_core_id = 0;
 	int max_package_id = 0;
-	int max_die_id = 0;
 	int max_siblings = 0;
 
 	/* Initialize num_cpus, max_cpu_num */
@@ -7084,8 +7084,8 @@ void topology_probe(bool startup)
 
 		/* get die information */
 		cpus[i].die_id = get_die_id(i);
-		if (cpus[i].die_id > max_die_id)
-			max_die_id = cpus[i].die_id;
+		if (cpus[i].die_id > topo.max_die_id)
+			topo.max_die_id = cpus[i].die_id;
 
 		/* get numa node information */
 		cpus[i].physical_node_id = get_physical_node_id(&cpus[i]);
@@ -7111,9 +7111,9 @@ void topology_probe(bool startup)
 	if (!summary_only && topo.cores_per_node > 1)
 		BIC_PRESENT(BIC_Core);
 
-	topo.num_die = max_die_id + 1;
+	topo.num_die = topo.max_die_id + 1;
 	if (debug > 1)
-		fprintf(outf, "max_die_id %d, sizing for %d die\n", max_die_id, topo.num_die);
+		fprintf(outf, "max_die_id %d, sizing for %d die\n", topo.max_die_id, topo.num_die);
 	if (!summary_only && topo.num_die > 1)
 		BIC_PRESENT(BIC_Die);
 
-- 
2.43.0



