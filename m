Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B317A409283;
	Wed, 16 Sep 2026 19:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789586917; cv=none; b=NZ31fgo4h6x/Hr8I1lz3M5XZAhC2rDd2sZLs4AJTM6My2j4E+yufXxkqxafM/r9JhYuA2zc6cYz+8qvZZh94kqP6KE7SyMfZ0V9++Hs9zl+DfOJBTXFcJU1/agO0+6rWX8U4W/asHEZtUzt2Lvdbx/zpNhKUKoEkFAqIP9N1cN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789586917; c=relaxed/simple;
	bh=0bJaaKoqdjAy4JIFbblOZHdpKP4X74BmmExo7ToUpgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SWpf2lMxw/D9SLD5zVKOUF/VrnZ8U9tyydiC/wMUG10sTADR+p38BI/etX6gyiL5KDPTWAxkCWBcQmRbASUkSUSOSk+hyT1POOgJGPC4aQtQp8SUKPR4NSX5tqnD9Vs4+TC7wvFzbXcgDmwOuO8UVxaEUBQOuer8SnFV7YDUqMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IcdV7Xz0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IcdV7Xz0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64CC71F00893;
	Wed, 16 Sep 2026 19:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789586909;
	bh=m0JMSQmCxg2yq7JRGPT0DS8H/8vd2AmabFaKZhjtFHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IcdV7Xz0UHoH3CWEb0g8/32fONmu8sECybrIEccC6WxSCGySfhs1iZqiymXVUlPPb
	 TfxdyQw0t4rriXOl6eGpox/J8wKrgjmJjLnx6tjyDn3gZrWHfY7/idzetz0FaLki7Z
	 2WIjjqOd6UHwb/kKsu9yZlm1+Vl0yIkOK0N412h/oHPV9Qg51I4BqDzeEmv6fuehce
	 bh5ZKd2cUB/AAToA6a648QNnpycUqN8ReINRfmUQjJMPdnuPHRL72UPHbqaJae8FR3
	 xWtg3O++IW6M4HaJpB1UYyctqylWHnk9Nm1UIPQP0mm8UTtIK9PqBDdsjqKFZMlWjF
	 TZVS3k2HZO3LQ==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 0709/1376] iommu/tegra241-cmdqv: Dont run the error ISR before probe sets up vintfs
Date: Wed, 16 Sep 2026 15:27:54 -0400
Message-ID: <daily-reply-20260916-0004-re-tegra241-cmdqv-isr@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <03fc4a7e-1cfd-47cd-8a79-7b6386d8eae6@oracle.com>
References: <03fc4a7e-1cfd-47cd-8a79-7b6386d8eae6@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> This is a multi-commit initialization and lifetime model, not a safe
> reorder alone. Maybe we should be reverting or queueing more commits. 
> Thoughts?

Queued cbc41aacd49e ("iommu/tegra241-cmdqv: Publish an LVCMDQ only after it
is fully initialized") for 6.12.

a491be376abd ("iommu/tegra241-cmdqv: Synchronize the error ISR against VINTF
(de)init") does not land there. Its Fixes: target is v6.17-rc1 and 6.12 has
no iommufd viommu infrastructure, so the hunk carrying the memory safety
payload rejects outright.

That leaves 6.12 with the narrow probe window you describe: the threaded IRQ
is still requested before vintfs[0] is published. Closing it properly needs a
purpose built 6.12 patch rather than a backport, so I am leaving it open for
now.

-- 
Thanks,
Sasha
