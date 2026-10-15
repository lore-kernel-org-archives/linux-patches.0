Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3EC1195B1A;
	Thu, 15 Oct 2026 00:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792022933; cv=none; b=Jw0VXyyuYfqsMlR9KhTHte/EaSn/fhjOd3By0A/tAHIBhmC6CVAi6mhJlzlyVwR5fXpIuKbMBjKtnuuHJ/A05W0uukniANo1N5wk3rKN+4Rci5mucjQHHqgBhfXsD3JQObY0GzO8K1OTUe9uNXutf+o+uSGXA/BfWtoGX+0vVvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792022933; c=relaxed/simple;
	bh=zQUCN1uQU3wfsLEkPomephOkww35JszLVZcHOC3a+tM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YOVH9DmgmGmysyytAOUOWQizjK6rS7PxtpNjXmex47iilUbSj+W7GQ8veGbhNmT+/psEGXiGqewSUdRoA2Y8/MwJpQtkTCSLVyFwo5Ktp5l/pdB/9wdWBsEMKh8D7CBVdqw/IvaXVV0+hJiwKRC7fyh0haVeMZ8rf9KuSR3hk7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=orMOgKCJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="orMOgKCJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 893341F000C6;
	Thu, 15 Oct 2026 00:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792022932;
	bh=Sq/rXTk/gn6tq7h2+o8e+zay6B5MA1AX74U4UpqSY3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=orMOgKCJYmgNWEzZD3UFUUNwR4X5W/eze9n3FVdUanUArGsgT0WIgYIV0nhLQl08q
	 MqTRdhJmZye3mm5nU9NguipqyzvOrV+YkKo+UWEI/xH00tMHuOxaz7bhBsWxNG/omN
	 cA3CdTk0t3L6OuXgZeKT5MMZ7snQxuaKYGb9v5q4U4+xjMw5urXApTF+UlKfmChIEN
	 olROFlXpay8VwKGjewvBZrQZcqiNPs/55bxVZCSjb7o1pocsJqReTaU9k2RWyFkpYd
	 t0rUhDNA24symQJo5CQl1mAGp5ZWnZfx/NxaT5G3ReMbZfB7cVNMLA3VvHv+s4imL3
	 UxeG8UEIKcl7w==
From: Sasha Levin <sashal@kernel.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 6.12 285/497] arm64/fpsimd: signal: Consistently read FPSIMD context
Date: Wed, 14 Oct 2026 20:08:40 -0400
Message-ID: <48c26a7dde7c421784031755@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <d21b3568-d14e-451f-a048-0655a4138d15@oracle.com>
References: <20261013112907.864180619@linuxfoundation.org> <20261013112914.660106209@linuxfoundation.org> <d21b3568-d14e-451f-a048-0655a4138d15@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> If live FPSR/FPCR changed since the last save, the new size error can
> leave older same-task values for the SIGSEGV handler. this patch adds a 
> size rejection route. The missing behavior comes from 929fa99b1215

Keeping this one in the queue. The new size rejection is only reachable with a
corrupt frame size, and the flush-then-error pattern already exists in 6.12.

Taking 929fa99b1215 and d3a181588df9 alone would break CONFIG_COMPAT, because
signal32.c still calls fpsimd_signal_preserve_current_state(), so it would also
need 3aa4d74438afa. That is not suitable for this RC.

-- 
Thanks,
Sasha
