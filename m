Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6795B1774B;
	Thu, 18 Jan 2024 10:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575535; cv=none; b=e3GE7mG3Aq8hHQQxEAFhMS8DQ8jhz2Gr78rXWQ+xpt7qmLWZSZXiqkRjaL7dcc2CF4GAZ3Ll8v9n0fkc5PbxF1+OapUvpx9VJDjUuhG/C8WTymsEWpKO92Y1u1pS39OIhlCFF7zSCmwVoPjhKT3GnELQ/JgHfb/MnT+Sh95+rpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575535; c=relaxed/simple;
	bh=buRP8Ow8R8SgyW9eeHoy6PnkVMmK8+oay+RKIEAH2sw=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=Ts4NNCYqZmmFUKrKhhsZy8k5uvw7hYciI+dP6SI4Ksu6mrXU24rNsMfVtICPK+fkGQaHIHnQq0oHvDN4yqsjS5H37hDB+iI+9HsB0sPu0m/wfU1cvhMdcneTdyGk7y7VASb0uvCuaIBhXnKgTSArhijxICkPqgdl5ZPIwtxtBuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pKeR4TY4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pKeR4TY4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE7DC433C7;
	Thu, 18 Jan 2024 10:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575535;
	bh=buRP8Ow8R8SgyW9eeHoy6PnkVMmK8+oay+RKIEAH2sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pKeR4TY4hCHcZGUWeXgfSRPwysXbzE9rOfzo+TOB/DShZUkJcNHfZ4J2iG9YHO7nC
	 y7ASenc6qp00bF+xi720j0M8tWJFlNkoFr4Z267O7ezngxQQpRi+1Q0fkaZVobanOo
	 fcUtAeAaLgropYdiuedgkBIxkiosPYQEThXA2mho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yicong Yang <yangyicong@hisilicon.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 017/100] hwtracing: hisi_ptt: Dont try to attach a task
Date: Thu, 18 Jan 2024 11:48:25 +0100
Message-ID: <20240118104311.665625058@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yicong Yang <yangyicong@hisilicon.com>

[ Upstream commit aff787f64ad7cbb54614b51b82c682fe06411ef3 ]

PTT is an uncore PMU and shouldn't be attached to any task. Block
the usage in pmu::event_init().

Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20231010084731.30450-5-yangyicong@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/ptt/hisi_ptt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hwtracing/ptt/hisi_ptt.c b/drivers/hwtracing/ptt/hisi_ptt.c
index 11f26ef709c9..8d8fa8e8afe0 100644
--- a/drivers/hwtracing/ptt/hisi_ptt.c
+++ b/drivers/hwtracing/ptt/hisi_ptt.c
@@ -659,6 +659,9 @@ static int hisi_ptt_pmu_event_init(struct perf_event *event)
 		return -EOPNOTSUPP;
 	}
 
+	if (event->attach_state & PERF_ATTACH_TASK)
+		return -EOPNOTSUPP;
+
 	if (event->attr.type != hisi_ptt->hisi_ptt_pmu.type)
 		return -ENOENT;
 
-- 
2.43.0



