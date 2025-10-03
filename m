Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E069829BDB5;
	Fri,  3 Oct 2025 16:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759507652; cv=none; b=VZymU//Gge5V2hCf2BNL43koqHu+M4tHH0pylYdGZzWfsv82AVIWuQ3UKHNBKK5JdhRXsx/d0f6xYurf3slsJmwDECDdmRBtAQFmGj8a7YTstOle5FGP/yLDeb+cPVcWFuN+SS6b+jDtHC34fljB/m8IkQBd01puCnsIx4BvQac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759507652; c=relaxed/simple;
	bh=D7oFl6F7tO4a/hoti1V+WR2s0ehZkL83vLuzGJQXAYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bUkKfv6fcE3ADnmRmmwkwbzdazuJU6gWKjt4Xl5Q8VgONX2tkvtGR35GL+ZdXvkAo4or3sC6qEZ3K7O76gN0a8cY7D8XbDkTY5svrn1IM3pGDK9YRLiJBwZXTXhNrKwuKuOHfFkYZrykoR3LCPrdNjYaql7l97flSKojaMCGIKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2FFEI7wj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2FFEI7wj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63614C4CEF5;
	Fri,  3 Oct 2025 16:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759507651;
	bh=D7oFl6F7tO4a/hoti1V+WR2s0ehZkL83vLuzGJQXAYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2FFEI7wjxEaCCdqA4epN8cFH3tdciS7dhnhgR/yR3Y/LkvrtCDa8ix23noxj6EFXK
	 ak3t9aV0A/+xfx3sVZRbvbW0tR+ARgx4239GoPsETdT8Qf+PBVm/27vOPww3NqV4ST
	 eEZ5pvrrVc7OkNMzwgzF+8eUhBexzYx3XnHVRa/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Subject: [PATCH 6.16 12/14] media: iris: Fix memory leak by freeing untracked persist buffer
Date: Fri,  3 Oct 2025 18:05:46 +0200
Message-ID: <20251003160353.060321369@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251003160352.713189598@linuxfoundation.org>
References: <20251003160352.713189598@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dikshita Agarwal <quic_dikshita@quicinc.com>

commit 02a24f13b3a1d9da9f3de56aa5fdb7cc1fe167a2 upstream.

One internal buffer which is allocated only once per session was not
being freed during session close because it was not being tracked as
part of internal buffer list which resulted in a memory leak.

Add the necessary logic to explicitly free the untracked internal buffer
during session close to ensure all allocated memory is released
properly.

Fixes: 73702f45db81 ("media: iris: allocate, initialize and queue internal buffers")
Cc: stable@vger.kernel.org
Reviewed-by: Vikash Garodia <quic_vgarodia@quicinc.com>
Tested-by: Vikash Garodia <quic_vgarodia@quicinc.com> # X1E80100
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-HDK
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-HDK
Signed-off-by: Dikshita Agarwal <quic_dikshita@quicinc.com>
Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org> # x1e80100-crd
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/iris/iris_buffer.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/media/platform/qcom/iris/iris_buffer.c
+++ b/drivers/media/platform/qcom/iris/iris_buffer.c
@@ -410,6 +410,16 @@ static int iris_destroy_internal_buffers
 		}
 	}
 
+	if (force) {
+		buffers = &inst->buffers[BUF_PERSIST];
+
+		list_for_each_entry_safe(buf, next, &buffers->list, list) {
+			ret = iris_destroy_internal_buffer(inst, buf);
+			if (ret)
+				return ret;
+		}
+	}
+
 	return 0;
 }
 


