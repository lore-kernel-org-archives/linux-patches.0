Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E62183CB0;
	Tue, 10 Sep 2024 10:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963207; cv=none; b=gb8XAirOTyu0Fm0Vi/8r2KJiRroos9opLpIXpA1kejJWA0SufOjVtm+dFKPzZdj+zvPtUtlMdhxbOVYTYIEgeekjB17PpJ0cTDyg8ePSY0jsHB6zgqy0Rg2wODn8zGxEvLK4gA9b1FilVbmDKvpK5LNmXHQxsxUfIbdpIl8X4r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963207; c=relaxed/simple;
	bh=ws94GRKAy6GDAyIuuGR3Li7xlAsJj9cH0ZG+gKqVONE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dr8aft5Hhb06J6u2dLgOmesr8e5eDYSY8spEfQtZ+/supii9Ia/0GBFCu3klv7Q7YC1dhRVdNmKIS0aDgmlAJYvWDW1Sk5wLi481KotE2OHOvIfNaMok6m3x0e1XrEk8pBiC3ioOG8W9ugTQK/yqAinIDbPsA5DJqj5fkr4YTTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A556OIiS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A556OIiS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69163C4CEC3;
	Tue, 10 Sep 2024 10:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963206;
	bh=ws94GRKAy6GDAyIuuGR3Li7xlAsJj9cH0ZG+gKqVONE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A556OIiSy5KFYXotVT8PZRby1k0LKeilovbuh8yQJ3J7YvnYzYRkBRsSdAllAt8va
	 X/M/n1EO6/e+aeke8FUJH1TdfL6LGoOvoyufrVTr2L8O1sttfrmHks3x6ehtbcE5UW
	 SJ7U2EdjnLBIR44blpsOVlJe7DXTYbwCHiA2CBUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Jens Axboe <axboe@kernel.dk>,
	Felix Moessbauer <felix.moessbauer@siemens.com>
Subject: [PATCH 6.1 134/192] io_uring/sqpoll: Do not set PF_NO_SETAFFINITY on sqpoll threads
Date: Tue, 10 Sep 2024 11:32:38 +0200
Message-ID: <20240910092603.533066733@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Koutný <mkoutny@suse.com>

commit a5fc1441af7719e93dc7a638a960befb694ade89 upstream.

Users may specify a CPU where the sqpoll thread would run. This may
conflict with cpuset operations because of strict PF_NO_SETAFFINITY
requirement. That flag is unnecessary for polling "kernel" threads, see
the reasoning in commit 01e68ce08a30 ("io_uring/io-wq: stop setting
PF_NO_SETAFFINITY on io-wq workers"). Drop the flag on poll threads too.

Fixes: 01e68ce08a30 ("io_uring/io-wq: stop setting PF_NO_SETAFFINITY on io-wq workers")
Link: https://lore.kernel.org/all/20230314162559.pnyxdllzgw7jozgx@blackpad/
Signed-off-by: Michal Koutný <mkoutny@suse.com>
Link: https://lore.kernel.org/r/20230314183332.25834-1-mkoutny@suse.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Felix Moessbauer <felix.moessbauer@siemens.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/sqpoll.c |    1 -
 1 file changed, 1 deletion(-)

--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -233,7 +233,6 @@ static int io_sq_thread(void *data)
 		set_cpus_allowed_ptr(current, cpumask_of(sqd->sq_cpu));
 	else
 		set_cpus_allowed_ptr(current, cpu_online_mask);
-	current->flags |= PF_NO_SETAFFINITY;
 
 	/*
 	 * Force audit context to get setup, in case we do prep side async


