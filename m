Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18AE03B6BE5;
	Tue, 21 Jul 2026 22:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672522; cv=none; b=DFCxp8a2F8tpX/vJhyEeXwtqcPqB7sojcPeU5AhlDZR6SwQG0aK1c3Et09hiAcjhvMH0bhg+9/jh9qPp1SP5dVSvh3oQrwzoCr/MR+7/WL9XQ9uWCe4tUer91jfVUr3UHrLSjg6eH9q2jRyHTBpcfP1IoARyT95DdCmT4FzNdxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672522; c=relaxed/simple;
	bh=c/uOZ7Q6z791wBB5wY9jXJOvQtLC/PxQ+SJjKorIhik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jKcrnWhM4Vl0yiRK1t+q7aYhIouk1sAlAG6UFXMHL+CeM4S13k+/Ic4i/T/2xd81s/J3or+iRvEKqWriKlvrio6T+f1IGn1V0MIu0xi3uu8rg+Z3hNn5yG9Elqi2cz16HcYRiXt7ZKkoxJK4RXB9umr1sLjJ7SGcaYCBRRlRHEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=awlgAOFR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="awlgAOFR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A55AE1F000E9;
	Tue, 21 Jul 2026 22:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672521;
	bh=MXag/B9idfg5qGl5d3EZbbJb8BNx8ATZlxjphHfj2gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=awlgAOFR37wGwFjtoAgnvJZ6Ak267Uce0BsHduUhUmTETj0yjnH5kFqaKU82eMRc1
	 R45EsAoLIIrPJ1FIZ3l6Gj6+NPKJCT+WIYubQpGTKGzh4eqPerdRuPPSyrc3oS4ZoA
	 G6QCqkU0x2lY2u04SzKoiOMstwJpPn7Z5q1wk3RU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.15 656/843] dm-stats: fix dm_jiffies_to_msec64
Date: Tue, 21 Jul 2026 17:24:51 +0200
Message-ID: <20260721152420.824635473@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 386df1a57b631c456d14f857cb0c0c2e11c16bef upstream.

There were wrong calculations in dm_jiffies_to_msec64 that produced
incorrect output when HZ was different from 1000. This commit fixes them.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Fixes: fd2ed4d25270 ("dm: add statistics support")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-stats.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-stats.c
+++ b/drivers/md/dm-stats.c
@@ -823,10 +823,10 @@ static unsigned long long dm_jiffies_to_
 		result = jiffies_to_msecs(j & 0x3fffff);
 	if (j >= 1 << 22) {
 		mult = jiffies_to_msecs(1 << 22);
-		result += (unsigned long long)mult * (unsigned long long)jiffies_to_msecs((j >> 22) & 0x3fffff);
+		result += (unsigned long long)mult * ((j >> 22) & 0x3fffff);
 	}
 	if (j >= 1ULL << 44)
-		result += (unsigned long long)mult * (unsigned long long)mult * (unsigned long long)jiffies_to_msecs(j >> 44);
+		result += (unsigned long long)mult * (unsigned long long)(1 << 22) * (j >> 44);
 
 	return result;
 }


