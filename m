Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2417B13CF89;
	Thu, 11 Apr 2024 10:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832169; cv=none; b=GhmEbndv6Fm3pPSpEXu5d4VGZZ1WPmmLHZuUb0UAjG7QKccTGGzfQkvWLjnWaCfhN9emEo4Wx/t+/XGKugiutpHjNooEDa4dEwM7a92ORMgz6c8gzbuXWQZ4v6mVWgQ7NYZFRjxS4waGE79cAkAYsDB/oohOV0zkpreqh+iB3uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832169; c=relaxed/simple;
	bh=u4vDYpKlutpZH0pLm/zi8JeIRio7IA9/WJSBlJx84n0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0KU1KTHQPKf9NQ7dLr1PJj7kEhgTrSFHmaccYD1K5IPtJisSXnSdHTYO/GnY3eVZTGWQVXltT+4nq6VZiR8pRkVbQi13lykgFu3XjmZTYTQJm40WesWW3ETp0xDsmED5V93dS1MJqZIL53nKnOGGu6OLf3xrjSE2NfKtvr0gCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tdNFhD9g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tdNFhD9g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A6BCC433C7;
	Thu, 11 Apr 2024 10:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832168;
	bh=u4vDYpKlutpZH0pLm/zi8JeIRio7IA9/WJSBlJx84n0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tdNFhD9gnUMJBweyAk0gYhv1hN7wAX6tU40NVbJmMAQUlxLtasZ6p+F7Z5/S/+vXx
	 OlBEzxTcLV3gWraa2kRGQyR7muzxUQ6PZds0Q3So69m3ERjaS5bRl8lLg1qXn+tLIy
	 EaBV7C17Y2oTW27D6tBu3olxmw+B0rghxTiqRtE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samasth Norway Ananda <samasth.norway.ananda@oracle.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 252/294] tools/power x86_energy_perf_policy: Fix file leak in get_pkg_num()
Date: Thu, 11 Apr 2024 11:56:55 +0200
Message-ID: <20240411095443.154388719@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ff6c6661f075f..1c80aa498d543 100644
--- a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
+++ b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
@@ -1152,6 +1152,7 @@ unsigned int get_pkg_num(int cpu)
 	retval = fscanf(fp, "%d\n", &pkg);
 	if (retval != 1)
 		errx(1, "%s: failed to parse", pathname);
+	fclose(fp);
 	return pkg;
 }
 
-- 
2.43.0



