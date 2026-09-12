Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66BBE386C21;
	Sat, 12 Sep 2026 11:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212809; cv=none; b=L6JJTFvhByjp2KG1EXVyTK9Zzea1GWHO2Q5WAEY7fZtWwWeLzhxTAgCXC9ZdHXlloDgOj9NzmOQqPsJHiNl+Itr3mbGQuAKwufjilk774hI0Hi7w+BvqRlHaKaPYbkx5cSxXV+MbjzOVLwjE2N0OgvjAefDUM559i01GAGoIAm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212809; c=relaxed/simple;
	bh=CrpzW5Fn+cc1rc8++U6SPLDnlyhnEXDcYCK4cgvY3wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rk1uVGI/ImLExCaB3vBalHFOOIuvN7bDginS26K70H9Qda8dfMy/gW0F5COSNnt0aplqk7Z3F62k5rpthHD1dStA0W1+wPepfWRXH4SMYJhDsi/0Ux277Gn5Yra62XlT5z2n4saoTOmOl/rwtolCvWdQbowWJ6NbxiQ0wIHbkMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2nPt0kYL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2nPt0kYL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05CA71F000FF;
	Sat, 12 Sep 2026 11:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212808;
	bh=oDSeo/5IlIOTShpEa0gLWbVqx6phqWL8//nYnki+baw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2nPt0kYL4nG27G3B/sNB0DQye3tkOraarctA1j4CF1lFeKWiUr/95NJSiqVKRVca4
	 OloDYGclpOwlHqxC51vGa6mzSDyjg9raIQ92uMl2WmPse4qBC0Wz+8eNZzFNPXDVbZ
	 Nz454BcPp3N7QVYQWsX7EY3fPL/lSwlaysUiEYyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1510/1518] cpufreq/amd-pstate: Allow writes to dynamic_epp when state isnt modified
Date: Sat, 12 Sep 2026 09:01:19 +0200
Message-ID: <20260912065657.724630221@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: K Prateek Nayak <kprateek.nayak@amd.com>

[ Upstream commit c5eed6ddc757e477f52b3d99bfde9e59975c72ca ]

Writing the current "dynamic_epp" state to sysfs fails with -EINVAL even
though the desired result was achieved. Allow writes to "dynamic_epp"
that does not modify the state.

Fixes: e30ca6dd5345 ("cpufreq/amd-pstate: Add dynamic energy performance preference")
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
Link: https://lore.kernel.org/r/20260508051748.10484-4-kprateek.nayak@amd.com
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 12b8ac0f4204b..b1a200531628f 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1719,8 +1719,9 @@ static ssize_t dynamic_epp_store(struct device *a, struct device_attribute *b,
 		return -EINVAL;
 	}
 
+	/* Nothing to do */
 	if (dynamic_epp == enabled)
-		return -EINVAL;
+		return count;
 
 	/* reinitialize with desired dynamic EPP value */
 	dynamic_epp = enabled;
-- 
2.53.0



