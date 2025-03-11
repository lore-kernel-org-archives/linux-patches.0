Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243D325E820;
	Tue, 11 Mar 2025 15:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705553; cv=none; b=PcM8BUANCYdL2lYjTA9NYKdCYZ9zAefMD9JCzLXw7pX1jPa5Nt61jtkmay/Bs0KuNRcce+82rsq6qE4cs+NAnHbK1MicYaxmexFp+peUj1TgA1cjRGAIuSH5X/jVCxuaPP4K9+C34KU26l8liQoDlAoa8wKPaPIIUieJndWr2Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705553; c=relaxed/simple;
	bh=cukIYENDLyOTLXoRos3k0vtulIJIAtu9RMD0iRXn6aU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mpx8rM2PC+mQIfah+X/oEwJn1UHu1ExlCCrxfsqFwNZwDMU+cBFLT3v12+gPeBfN4CnzVna/kWp3p2SlQxpWr3ElZxNVMwFgk1BCsw4uswTFT3qqvz1eAfrHTQHDTLjgKCCPPcFpmS7U2Jye2JP7QlYjA9mcmSRkUpb+DSMd0q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WoAqfkHq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WoAqfkHq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9239BC4CEEA;
	Tue, 11 Mar 2025 15:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705553;
	bh=cukIYENDLyOTLXoRos3k0vtulIJIAtu9RMD0iRXn6aU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WoAqfkHq9w10hI7IUAUmnAGkEW0gemXd/tdo0UapoLk8I7hrnCKstIL05H5h52Vku
	 h8Z20ss7azt6dDMgPa9pf8mkr1lvWp2vIJOS6F9WZ4Dm0NcO0jKEcmdrh3ieumg/Va
	 F0oPtHCWtkUBUk1prrdW57GqgRCHwr89x5VKcnjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Yujun <linyujun809@huawei.com>,
	Brian Cain <bcain@quicinc.com>,
	Brian Cain <brian.cain@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 074/328] hexagon: Fix unbalanced spinlock in die()
Date: Tue, 11 Mar 2025 15:57:24 +0100
Message-ID: <20250311145717.833875854@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Lin Yujun <linyujun809@huawei.com>

[ Upstream commit 03410e87563a122075c3721acc7d5510e41d8332 ]

die executes holding the spinlock of &die.lock and unlock
it after printing the oops message.
However in the code if the notify_die() returns NOTIFY_STOP
, die() exit with returning 1 but never unlocked the spinlock.

Fix this by adding spin_unlock_irq(&die.lock) before returning.

Fixes: cf9750bae262 ("Hexagon: Provide basic debugging and system trap support.")
Signed-off-by: Lin Yujun <linyujun809@huawei.com>
Link: https://lore.kernel.org/r/20230522025608.2515558-1-linyujun809@huawei.com
Signed-off-by: Brian Cain <bcain@quicinc.com>
Signed-off-by: Brian Cain <brian.cain@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/hexagon/kernel/traps.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/hexagon/kernel/traps.c b/arch/hexagon/kernel/traps.c
index f69eae3f32bd2..ec98052b148d1 100644
--- a/arch/hexagon/kernel/traps.c
+++ b/arch/hexagon/kernel/traps.c
@@ -202,8 +202,10 @@ int die(const char *str, struct pt_regs *regs, long err)
 	printk(KERN_EMERG "Oops: %s[#%d]:\n", str, ++die.counter);
 
 	if (notify_die(DIE_OOPS, str, regs, err, pt_cause(regs), SIGSEGV) ==
-	    NOTIFY_STOP)
+	    NOTIFY_STOP) {
+		spin_unlock_irq(&die.lock);
 		return 1;
+	}
 
 	print_modules();
 	show_regs(regs);
-- 
2.39.5



