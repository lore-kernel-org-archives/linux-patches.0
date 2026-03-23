Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB15C3AE19E;
	Mon, 23 Mar 2026 16:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283010; cv=none; b=LC19etYMY411AdsuhJkB7QJy0cWEIDCuN00/l33yFwdMUKOglbQWhMTdQ2Nm+bo2aos1Ds0FtjJUl46YTVUPHIG+Qtx187bC9dGK9uOpBSqfMZSM2iqQBroiW+kSJ/dVfGr5L+YdZjqsH+/xj5RZz+PTW5Zpc+ssRem2Y7rkxDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283010; c=relaxed/simple;
	bh=N0Lyu3VurFz66J7kTVq7d+mfmPuIl/BWX5m3SkpZUXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F5AvsZGYUdJqxIGA3C44NB6+HIZPTvH/fNmhHJPeDvIJv/bZFf8UOZDs6lKhe5O3OiMwZS5h5uxnVmDbNTtE1LFSP+h+9sO3xIK8hHtSza5xmLdFnnFoBAoLa+GWRU9nUQUJ5xww8jhw3zE5qFeaSicwpjFxUuyKFVh/mFtukgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1hU8dL0t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1hU8dL0t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62925C4CEF7;
	Mon, 23 Mar 2026 16:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283009;
	bh=N0Lyu3VurFz66J7kTVq7d+mfmPuIl/BWX5m3SkpZUXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1hU8dL0t0YKXGp6HZlTCG15BGDbJr30XwnAu11tWgzoiYTwqwse4Po6eAfd95sm0H
	 1r5kHV/c6VHWAYQXihWG0JUqpQSl7MEFpF8FNURcvbxEZ6B1sSgY0afrnTLt42xk97
	 PIZ5uO0UFq+lvanAR7tGKAr3EQvrlKZ/w/oKxfEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Schmidt <mschmidt@redhat.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Simon Horman <simon.horman@corigine.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Sunitha Mekala <sunithax.d.mekala@intel.com>
Subject: [PATCH 6.1 366/481] ice: sleep, dont busy-wait, in the SQ send retry loop
Date: Mon, 23 Mar 2026 14:45:48 +0100
Message-ID: <20260323134534.039096312@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

From: Michal Schmidt <mschmidt@redhat.com>

[ Upstream commit b488ae52ef9f74155ab358f8c68e74327b45e0e1 ]

10 ms is a lot of time to spend busy-waiting. Sleeping is clearly
allowed here, because we have just returned from ice_sq_send_cmd(),
which takes a mutex.

On kernels with HZ=100, this msleep may be twice as long, but I don't
think it matters.
I did not actually observe any retries happening here.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Tested-by: Sunitha Mekala <sunithax.d.mekala@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: 326256c0a72d ("ice: reintroduce retry mechanism for indirect AQ")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -1620,7 +1620,7 @@ ice_sq_send_cmd_retry(struct ice_hw *hw,
 
 		memcpy(desc, &desc_cpy, sizeof(desc_cpy));
 
-		mdelay(ICE_SQ_SEND_DELAY_TIME_MS);
+		msleep(ICE_SQ_SEND_DELAY_TIME_MS);
 
 	} while (++idx < ICE_SQ_SEND_MAX_EXECUTE);
 


