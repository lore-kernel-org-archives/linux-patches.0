Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4711C1A4F19;
	Wed, 20 Nov 2024 12:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107522; cv=none; b=HQAIL79+ZvZWKH/hWcWMvUfjHvl/iv/d0lL15wJDbvJShOGNySgoGyezm+HknUfIQf0Gcr4+z4kyOp+p8eQPvJe2Bspu8R2FOzhUXKM3lu35rfHEgeEaD7K1MKJVq9c9h4rWzr2TPxiLDjHS2wo+inISQism8OoYFOldqCjbu04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107522; c=relaxed/simple;
	bh=la762hvUdGugMzGpRRb2sSF55DX6i2pZI18Wqp7yPiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CE4CIk92wkgbyYUqNpWXedaoKi3CzrBFLSq29HjN1VcU61tIyPfZ2FtPM2RaV5QcRmxpYeXuvngZcfzErB5hprpZzNSBv2cW2sxsueyKIGWTdBSmVjnqdXgtBxZg2RQ1dqICP5Gcymx78rq/SVJsR79huOgrI7LVhe2olUHqGcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P/jsZGJ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P/jsZGJ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6EEC4CECD;
	Wed, 20 Nov 2024 12:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107522;
	bh=la762hvUdGugMzGpRRb2sSF55DX6i2pZI18Wqp7yPiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P/jsZGJ0vKLUX86WDL9bvgpywCU5uKHZriVGkXp5dbsJl4jSzY4LMzGv8hI3skg7t
	 7vCRMSHfbaGwxAdy2FxrUGCXoJrTGQki8axqGDN2k2j9reDSDOvA8vr1s5muZA9s5p
	 LYhJXZAwkGGFDzJkx64p9d/jVlTcrInveTsK39XA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mateusz Guzik <mjguzik@gmail.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 6.11 053/107] evm: stop avoidably reading i_writecount in evm_file_release
Date: Wed, 20 Nov 2024 13:56:28 +0100
Message-ID: <20241120125630.872157258@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mateusz Guzik <mjguzik@gmail.com>

commit 699ae6241920b0fa837fa57e61f7d5b0e2e65b58 upstream.

The EVM_NEW_FILE flag is unset if the file already existed at the time
of open and this can be checked without looking at i_writecount.

Not accessing it reduces traffic on the cacheline during parallel open
of the same file and drop the evm_file_release routine from second place
to bottom of the profile.

Fixes: 75a323e604fc ("evm: Make it independent from 'integrity' LSM")
Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
Reviewed-by: Roberto Sassu <roberto.sassu@huawei.com>
Cc: stable@vger.kernel.org # 6.9+
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/integrity/evm/evm_main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -1084,7 +1084,8 @@ static void evm_file_release(struct file
 	if (!S_ISREG(inode->i_mode) || !(mode & FMODE_WRITE))
 		return;
 
-	if (iint && atomic_read(&inode->i_writecount) == 1)
+	if (iint && iint->flags & EVM_NEW_FILE &&
+	    atomic_read(&inode->i_writecount) == 1)
 		iint->flags &= ~EVM_NEW_FILE;
 }
 


