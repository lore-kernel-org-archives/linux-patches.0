Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58D41DDCE;
	Tue, 16 Jul 2024 16:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146113; cv=none; b=gM1UqEcVWYVM6FuiUwjoz5QoWpsRV8YcryeDL+OVz10H+D+1T5hHabj8GiiETSGTfB1a5HkA2ilDqnvrB/Gkhybm/0Jg47CF7s8ung0VGLo+2TcH7Kk1Q044eH6EwhmVfjwjdQPk5Q/0V9FfmWlJ2JnEHprXILWWtSbl7GomReU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146113; c=relaxed/simple;
	bh=300OMV05tXxKBbmZTDAigMTc2MTl1GOPTB7FjWU8cAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dkyVpW8ObUqXQZBFa+n3waZrNvEURVy4kJ6K6AMIHvYPPSiTWCt5eaPpRtOG14Hczq3vi4jGkakr+9D3ULNFqsaeWjusS29S3YUZbh7UqEjc8+P3ejzIAg/hImjLpadCgQK66yf+Lh3VxeGLyLg/OFbxy5InHTkIwLe4205uZwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K47HAWQR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K47HAWQR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E49C116B1;
	Tue, 16 Jul 2024 16:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146112;
	bh=300OMV05tXxKBbmZTDAigMTc2MTl1GOPTB7FjWU8cAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K47HAWQRzvLlvV0CEJoJd1PvGSOWwhtvk6ZR56Yr+RzjY8nBmOg9wxRNbaY0p9qwz
	 cxYIsl/V8mphcDuSj1BedI3+2qJLJS7URghyKtwlAKVBl1YiQT4nlaBEt6jVVCNXO2
	 oJJ1bSVyEfPh4MWwg2BXXQi/N3RFUCgq8Qo58oVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 030/144] tools/power turbostat: Remember global max_die_id
Date: Tue, 16 Jul 2024 17:31:39 +0200
Message-ID: <20240716152753.699394605@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Len Brown <len.brown@intel.com>

[ Upstream commit cda203388687aa075db6f8996c3c4549fa518ea8 ]

This is necessary to gracefully handle sparse die_id's.

no functional change

Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 0822e7dc0fd8b..5a9fc659e8930 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -417,6 +417,7 @@ struct topo_params {
 	int num_cpus;
 	int num_cores;
 	int max_cpu_num;
+	int max_die_id;
 	int max_node_num;
 	int nodes_per_pkg;
 	int cores_per_node;
@@ -5614,7 +5615,6 @@ void topology_probe()
 	int i;
 	int max_core_id = 0;
 	int max_package_id = 0;
-	int max_die_id = 0;
 	int max_siblings = 0;
 
 	/* Initialize num_cpus, max_cpu_num */
@@ -5683,8 +5683,8 @@ void topology_probe()
 
 		/* get die information */
 		cpus[i].die_id = get_die_id(i);
-		if (cpus[i].die_id > max_die_id)
-			max_die_id = cpus[i].die_id;
+		if (cpus[i].die_id > topo.max_die_id)
+			topo.max_die_id = cpus[i].die_id;
 
 		/* get numa node information */
 		cpus[i].physical_node_id = get_physical_node_id(&cpus[i]);
@@ -5710,9 +5710,9 @@ void topology_probe()
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



