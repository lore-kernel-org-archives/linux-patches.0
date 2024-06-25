Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70BF11487E9;
	Tue, 25 Jun 2024 09:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309323; cv=none; b=U2FIHOv2jSfcrqM5FdwBhuOq/NYX+oFWv6fI52ea0SrSuKF/AfHlDU37IqhVRUmbBu5OI+ffwP6S1Z0rXe36pJrUg5mA4DR/gJ4fYDxR+KyCbOirYYl37zTVXmyV3CkHrb8jAVPS9+uuLaTJYPednCTx4YcJyYXEJxkrMDCSfyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309323; c=relaxed/simple;
	bh=6FsZDOFXTfBlvLR6Dp4OD0UrkiVAlPR+yvklo73rRDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T6ODVfgGagF3Jby+cDLtQ7p2TeLND+b9mbJeWDQ6uFwCNFtgkQemlL/47HA2Aw5zeobMoGXhbmFHFO4vSMkpx+a+33toRsL8l1YLuBqLvrHxj0udPObpL3K4gszmVe7GrDDjAnuDz4fogp21VPw9huR/yMQx4QeLAFQmhQA/0C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ehODACJr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ehODACJr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB5FAC32781;
	Tue, 25 Jun 2024 09:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309323;
	bh=6FsZDOFXTfBlvLR6Dp4OD0UrkiVAlPR+yvklo73rRDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ehODACJrI6RZtlPoWF+WU3mJDjUT9wiHOaKMf/esd+pMeXnsJFJD6HJUd+HtEgwxz
	 qkznfveafXJfprD4XhQzsq0xiKFNzYnQ6H9U56Nv6Ord9/Pt6YMIAuPL8g3AjJY+Ny
	 kAySNH56ToOClGAThAodvGfW4HNdEdz9w0vUBwgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrice Chotard <patrice.chotard@foss.st.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 170/192] spi: stm32: qspi: Clamp stm32_qspi_get_mode() output to CCR_BUSWIDTH_4
Date: Tue, 25 Jun 2024 11:34:02 +0200
Message-ID: <20240625085543.686007315@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrice Chotard <patrice.chotard@foss.st.com>

commit 63deee52811b2f84ed2da55ad47252f0e8145d62 upstream.

In case usage of OCTAL mode, buswidth parameter can take the value 8.
As return value of stm32_qspi_get_mode() is used to configure fields
of CCR registers that are 2 bits only (fields IMODE, ADMODE, ADSIZE,
 DMODE), clamp return value of stm32_qspi_get_mode() to 4.

Fixes: a557fca630cc ("spi: stm32_qspi: Add transfer_one_message() spi callback")
Cc: stable@vger.kernel.org
Signed-off-by: Patrice Chotard <patrice.chotard@foss.st.com>
Link: https://msgid.link/r/20240618132951.2743935-3-patrice.chotard@foss.st.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-stm32-qspi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/spi/spi-stm32-qspi.c
+++ b/drivers/spi/spi-stm32-qspi.c
@@ -349,7 +349,7 @@ static int stm32_qspi_wait_poll_status(s
 
 static int stm32_qspi_get_mode(u8 buswidth)
 {
-	if (buswidth == 4)
+	if (buswidth >= 4)
 		return CCR_BUSWIDTH_4;
 
 	return buswidth;


