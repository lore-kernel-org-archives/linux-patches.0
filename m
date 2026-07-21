Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7054D379960;
	Tue, 21 Jul 2026 23:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674837; cv=none; b=eqqYkX86Rmg73pSeR/00n7SL23jc44EMU9T8seOyJOEHfkFgKeRRRQmgbpLUt+gmrW8kSITuL0mXDGYeWgF7IUudulfl51nTkACl0SRVDPfITlJ9vdtuW8ch8PelexkVs1OCSKLMrdWdwQlmePiJDlWVB2hCcnRIbzl6HtuDAu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674837; c=relaxed/simple;
	bh=IktBVxb6U4k1GlnzhH5iSo0dUKSYBoIlUlkBaSa1lao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uwjG05uTSZ0flazAOuVtArB3mCv1OgrGhFDhorfie6Q7nesDkrtiEGu9wQaRtmrVI0Zxa+FtGrxH5Hju8bnxLkp9xlp3SSlnrWmnSfsPqFCORHPwPbsCPq9QLDTTh9ZkPCQ4j9X3dLNAlVtJxB4H8pz00TD5NH/k5wVfuxFa3YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XhVcBKl8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XhVcBKl8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D71471F000E9;
	Tue, 21 Jul 2026 23:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674836;
	bh=dMiGgI4uuayc/BjbTUBpcupDrJnTZCTknT6evt+HcDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XhVcBKl8WbXR/nyQ5QIHExcff87Az1akWIITQk8Gy9tpN1tlkwyGHMF6hhf+x6RQd
	 2U/iUML+wFT9tuSRahsArOll9wrgwT9iXf2DEGdMXLcbs+tmQkk/GETUXdn4v6irB1
	 JFWpGYJ7zktTx5Iq0Q2zq1TImanql3IFw69lWZX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Haibing <yuehaibing@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 692/699] ipv6: mcast: Delay put pmc->idev in mld_del_delrec()
Date: Tue, 21 Jul 2026 17:27:31 +0200
Message-ID: <20260721152411.387711567@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yue Haibing <yuehaibing@huawei.com>

commit ae3264a25a4635531264728859dbe9c659fad554 upstream.

pmc->idev is still used in ip6_mc_clear_src(), so as mld_clear_delrec()
does, the reference should be put after ip6_mc_clear_src() return.

Fixes: 63ed8de4be81 ("mld: add mc_lock for protecting per-interface mld data")
Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
Link: https://patch.msgid.link/20250714141957.3301871-1-yuehaibing@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/mcast.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -806,8 +806,8 @@ static void mld_del_delrec(struct inet6_
 		} else {
 			im->mca_crcount = idev->mc_qrv;
 		}
-		in6_dev_put(pmc->idev);
 		ip6_mc_clear_src(pmc);
+		in6_dev_put(pmc->idev);
 		kfree_rcu(pmc, rcu);
 	}
 }


