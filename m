Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE037175B;
	Mon,  8 Apr 2024 13:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581460; cv=none; b=coeYcQ/uzoOdM+/1Tx5ES2SxZpVdaqP6NSjJAJ+PkgGh7qayy8atIovbrbpnMfBAYF3ri3jEJau47l7qJ9TzG+xZ3cCInYHK5ej3SboWxK3+uOnGBSK4un8xT+y2XDe3I6QKI5z1mP4s0GtT3PD1JClMpacpu0j2/R8gbh62w8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581460; c=relaxed/simple;
	bh=Oi4YoKNspqn+fHxRvJnscXWei5awyVwRciCOIxGjj00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cI+a5dt9l+PU0vh7iiWlNUVioEV3gauGF7uTraaMWWhTrEEipQQ9RJSzr7VUvyow+sqifsGJy18iJqNIglVmccSor3S64V7OQVOqiEHkhGgLb9Oi9AsLOZ4MAZpXfodFoeGcNNECtr/y3dTnlbQa/jELOCOO1ze6MxFTWkoVH/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A0iTQh4p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A0iTQh4p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6C8C433C7;
	Mon,  8 Apr 2024 13:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581460;
	bh=Oi4YoKNspqn+fHxRvJnscXWei5awyVwRciCOIxGjj00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A0iTQh4p4xhVLi+O/Cl8GK4aBpaAlaCn0ivcJ59TBwg4fuvRBjHOH+YJIT2D8ZRl6
	 uH8G8AhcNLV+uxDpMQ48A8rYD86JHfDwwiqiVzsKHW+VGqOCsjA2lE/lZ1cEOi2izy
	 J9WYGGqGnERp7cl++JjHd05jbyyBehJfU4qxyiys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Igor Zhbanov <izh1979@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	sparclinux@vger.kernel.org,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Nick Alcock <nick.alcock@oracle.com>,
	Sam Ravnborg <sam@ravnborg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Andreas Larsson <andreas@gaisler.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 021/690] sparc: vDSO: fix return value of __setup handler
Date: Mon,  8 Apr 2024 14:48:07 +0200
Message-ID: <20240408125400.328628883@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 5378f00c935bebb846b1fdb0e79cb76c137c56b5 ]

__setup() handlers should return 1 to obsolete_checksetup() in
init/main.c to indicate that the boot option has been handled.
A return of 0 causes the boot option/value to be listed as an Unknown
kernel parameter and added to init's (limited) argument or environment
strings. Also, error return codes don't mean anything to
obsolete_checksetup() -- only non-zero (usually 1) or zero.
So return 1 from vdso_setup().

Fixes: 9a08862a5d2e ("vDSO for sparc")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Igor Zhbanov <izh1979@gmail.com>
Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Cc: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Nick Alcock <nick.alcock@oracle.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Link: https://lore.kernel.org/r/20240211052808.22635-1-rdunlap@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/vdso/vma.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/sparc/vdso/vma.c b/arch/sparc/vdso/vma.c
index cc19e09b0fa1e..b073153c711ad 100644
--- a/arch/sparc/vdso/vma.c
+++ b/arch/sparc/vdso/vma.c
@@ -449,9 +449,8 @@ static __init int vdso_setup(char *s)
 	unsigned long val;
 
 	err = kstrtoul(s, 10, &val);
-	if (err)
-		return err;
-	vdso_enabled = val;
-	return 0;
+	if (!err)
+		vdso_enabled = val;
+	return 1;
 }
 __setup("vdso=", vdso_setup);
-- 
2.43.0



