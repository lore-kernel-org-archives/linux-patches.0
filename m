Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D279146A9E;
	Thu, 11 Apr 2024 10:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830974; cv=none; b=ZQJg5C+dTodk4l4HX06hvmx6rTnML5uGqzpQVGilH7iaDHUQFNJe8+72nAWuzyRihSNvYe3i69CoyD6TdsgLhp+OvhCD7lrassXSg5whKgEOtD0WvI+wad2m723oUtQOGFSI6RPKDlbhjX30VAQmIVkxIWWZyXRgAvIhveW4j8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830974; c=relaxed/simple;
	bh=N+7I9VWoCeoy2uWOMJaTbqJqTHssuNMUqsP6tolpCaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nuQuctxBVgAdeS15FMIrc4uSiD76eRWCbF13XW+MfiAXIjnIZygvZ3yT8q5wUTYTWE+59kGHHvnVRB9x+GSQuoEpc1QZL3XK94+6srypwciUo6ZOcrpoUOrh6lnKWph35SJyJmANzexD1LtiRFQeFoLO05iLb9FBdRZWFD/lj5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=barPUGX3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="barPUGX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050DCC433F1;
	Thu, 11 Apr 2024 10:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830974;
	bh=N+7I9VWoCeoy2uWOMJaTbqJqTHssuNMUqsP6tolpCaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=barPUGX32siJvS+tDHhyvgRzAmnevDJ+Fh5mVsVJQjDwpg3UWCemZkzjMTGHWZpRD
	 DPfZEZophOU/dVq1tQlvJ9CwNPQn9kCl9VbXXloisWjbH4C+0NfS4syLGskDw6alNM
	 q0kwlXrBIhSsQLQDTrgW8ztxc77FosNmV319UUI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samasth Norway Ananda <samasth.norway.ananda@oracle.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 180/215] tools/power x86_energy_perf_policy: Fix file leak in get_pkg_num()
Date: Thu, 11 Apr 2024 11:56:29 +0200
Message-ID: <20240411095430.279086213@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>

[ Upstream commit f85450f134f0b4ca7e042dc3dc89155656a2299d ]

In function get_pkg_num() if fopen_or_die() succeeds it returns a file
pointer to be used. But fclose() is never called before returning from
the function.

Signed-off-by: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
index 3fe1eed900d41..165eb4da8a644 100644
--- a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
+++ b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
@@ -1111,6 +1111,7 @@ unsigned int get_pkg_num(int cpu)
 	retval = fscanf(fp, "%d\n", &pkg);
 	if (retval != 1)
 		errx(1, "%s: failed to parse", pathname);
+	fclose(fp);
 	return pkg;
 }
 
-- 
2.43.0



