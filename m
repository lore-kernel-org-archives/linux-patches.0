Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377863ACEFE;
	Tue, 21 Jul 2026 21:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670326; cv=none; b=aOud5397T/2RoPCUiKkcd04GIo3fnntLTUpQi+ThV7n3gyvQw6p15mKQ1PECBb2pMWtkAEza+lJJyl+WM5ijsgEzGOsOWk5750QYgDHYvWvigaDKoh/l8b/6o5H5bwbHvUmLrbOS2XH80SXW6HasfO68sG6BH50SBlYwQr/YYP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670326; c=relaxed/simple;
	bh=iqxsWv+kSLk/3ZBJOm5QSWyri4hSwg3YX5S7ZpDPrYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pzzleYJ3YUvJ5nc5rICvrQmTrywj3O+cgEdhZAPIOlgyV9cs5pA/lS6wzFX+JStbGV5b2JFRKaxKeJB27G3cYNJY5zqX4+yiuaP0Q1+IzsgfLNjQGWVr37jmAXfFyBf0Gwo0/eB5KUN2iEDBiXZrBN1GihgEcUl17p6AaHA+2wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DMADSNU6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DMADSNU6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CD6C1F000E9;
	Tue, 21 Jul 2026 21:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670325;
	bh=9p0TxIRdojP8aQ63X7baKA6A5EYqPqZnrvWxYsfqY0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DMADSNU6NCrSkR1rw5xvmYwHdBVpveuAXL98JqwMe7CeRCF7yAyFYhIhWx6ikRBUT
	 gOEPuf3n9S2/HhQ+h408pzUzC6g1654WCOx39i4K85vlVJKANOatHxZwwIiA/+o0yI
	 eikduSGmEidispqEx3+DPuObUd+gR/30RKqj7bMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.1 0847/1067] dm-stats: fix dm_jiffies_to_msec64
Date: Tue, 21 Jul 2026 17:24:08 +0200
Message-ID: <20260721152443.495375724@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -826,10 +826,10 @@ static unsigned long long dm_jiffies_to_
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


