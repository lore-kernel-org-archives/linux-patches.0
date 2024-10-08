Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C891DC046;
	Tue,  8 Oct 2024 12:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391778; cv=none; b=I1t5/vdBenRK3jRFOPWKkdg9WFbWctKPKoBnX6HBUANEIGuBrnjnDAKgzVMBkdMV6X0bMvx+tMZqAKdmVbhzEHgh2lYOByUZ0CRs+xPYL1+DRynIJU9vzyPwlAig7mGWrk6q3ctHYTvtpA4p5Voya8+iUZBbydOTMXbQ2CvgoHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391778; c=relaxed/simple;
	bh=CyFf2l0NhjM15/Tmy/jmXEGm9iqi4KDxW86YAkY0ra0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PVULgeiaUcOMoxsRcLE0yWBwolaG5wnooe3hJOtD/WuiXJR9Uz00cwVHafqL0HiBf3M6rU+Q+0MQmsERXxKH8WubwA4B3MxiBwA1chpyjSDwwCFl64Y/06n9SHTNLp7H9AUdu8K0oEuR8n59Zt90ilJPCFDMnyfQWg0muZps970=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J23oRzUn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J23oRzUn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07AB0C4CEC7;
	Tue,  8 Oct 2024 12:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391778;
	bh=CyFf2l0NhjM15/Tmy/jmXEGm9iqi4KDxW86YAkY0ra0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J23oRzUnfG9Q5a3iOYtCkbo8T3WYp+wKg9QoscCTcIRdSCMIH9Ty1+kA3ylw5Y3T2
	 2XJ1X5+4R18H+Sq6fJ71fCE2/7UYXm3YZSvhtgvebDyvqlws3eg8tjTGzGORwHmZRp
	 kw9rAw3YkxPAodIkobzbXDfyOqDP9Bw62eEwEdKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <olsajiri@gmail.com>,
	Oleg Nesterov <oleg@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 220/558] selftests/bpf: fix uprobe.path leak in bpf_testmod
Date: Tue,  8 Oct 2024 14:04:10 +0200
Message-ID: <20241008115710.999909701@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <olsajiri@gmail.com>

[ Upstream commit db61e6a4eee5a7884b2cafeaf407895f253bbaa7 ]

testmod_unregister_uprobe() forgets to path_put(&uprobe.path).

Signed-off-by: Jiri Olsa <olsajiri@gmail.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240801132724.GA8791@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
index fd28c1157bd3d..72f565af4f829 100644
--- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
+++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
@@ -477,6 +477,7 @@ static void testmod_unregister_uprobe(void)
 	if (uprobe.offset) {
 		uprobe_unregister(d_real_inode(uprobe.path.dentry),
 				  uprobe.offset, &uprobe.consumer);
+		path_put(&uprobe.path);
 		uprobe.offset = 0;
 	}
 
-- 
2.43.0



