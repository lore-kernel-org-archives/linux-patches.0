Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A365189504;
	Tue, 30 Jul 2024 16:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357370; cv=none; b=mLC8+4Ae2W7MlMxb6y/Txn7279sQk5Zq9k5NS1eM4nor4T32/jDZh3tc4f+Gnu0UgvzFWHkLf9oV3pC+mNXNjS9VMxV1sMzsjtoOeSfQEDnzFd+d+TxBYxxzEF2/tFqgmpgpzKBHPirZzhu2iSs4cjkoDxDKCFBjXhPJy6ObbpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357370; c=relaxed/simple;
	bh=QXBGMxcqU4AUbsY0Oz/wY5+nnTnLx5bG78reF3hkePQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OKsp9dH5u6yqcKqo78RvdMWzGwZXpEF+BPOYvce5m7tN113Uzt7gWdoJtn/kSnoVhz54OU150YE4QKwrwZEtqXXa2bWX52DXjiV7JlKtELl4XitpnweO7pzYX9jBflRr0fa1j2B7XBdb2DqLA0UdEu6S1LJvPth8mmgZ0o9TcPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QaiplNYa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QaiplNYa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB80C32782;
	Tue, 30 Jul 2024 16:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357370;
	bh=QXBGMxcqU4AUbsY0Oz/wY5+nnTnLx5bG78reF3hkePQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QaiplNYaMQDfk67NfZRyQVF6LacX8sWS8zgfsJEPekAbhPtfe41+HNCQ8/JMoFeBH
	 v6XdWtsXjo4EnPf8cUnDJMjgh5gVSQOYy+VRfx0Ilb5L4xVDWnBzYuGeO6W+aspx0p
	 LRPZEoyzRlnEA2fCedm9ro35iRL90bwj8/vIKtaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Stanimir Varbanov <stanimir.k.varbanov@gmail.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.1 286/440] media: venus: fix use after free in vdec_close
Date: Tue, 30 Jul 2024 17:48:39 +0200
Message-ID: <20240730151627.002479016@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dikshita Agarwal <quic_dikshita@quicinc.com>

commit a0157b5aa34eb43ec4c5510f9c260bbb03be937e upstream.

There appears to be a possible use after free with vdec_close().
The firmware will add buffer release work to the work queue through
HFI callbacks as a normal part of decoding. Randomly closing the
decoder device from userspace during normal decoding can incur
a read after free for inst.

Fix it by cancelling the work in vdec_close.

Cc: stable@vger.kernel.org
Fixes: af2c3834c8ca ("[media] media: venus: adding core part and helper functions")
Signed-off-by: Dikshita Agarwal <quic_dikshita@quicinc.com>
Acked-by: Vikash Garodia <quic_vgarodia@quicinc.com>
Signed-off-by: Stanimir Varbanov <stanimir.k.varbanov@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/vdec.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -1705,6 +1705,7 @@ static int vdec_close(struct file *file)
 
 	vdec_pm_get(inst);
 
+	cancel_work_sync(&inst->delayed_process_work);
 	v4l2_m2m_ctx_release(inst->m2m_ctx);
 	v4l2_m2m_release(inst->m2m_dev);
 	vdec_ctrl_deinit(inst);


