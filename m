Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35311B3922;
	Mon, 23 Dec 2024 16:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970152; cv=none; b=jzuYxtd6D288DApkX9OMyzkLWKNwr76AGdcZpYLQ49+eXwpl/TCzKyqXzBA1jHdYuqPlpEKHlFY6kXqoiaU7rppzJNYzkG5abZP6buiookRl9KQTMXbj7fHvGj4XbyosJhKGWTVOgbCY37Oq1uwh7NZVH15R1bLs5ME1iZ9Xb38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970152; c=relaxed/simple;
	bh=FLi3OEag2nMlhwJiTtjlx55glieJ4Z7+MFshq2nEC44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+PiAz33WUE2uSvhSexAFHP0YqXKB7Mh8NpsZGZVrWL8/YnZeYLQj38Am8ESwy0Qo460Xr2Yq3zlJNvSx8XU8I081An9Uam5uhc6EzTgwxw48snwhnhlLOge1ABlIZ0pSDOPq2WmNz51jOyTYAeJ1wvHDiqf1LiVxiEQNNcZrMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EOsd3tKH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EOsd3tKH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B837C4CED3;
	Mon, 23 Dec 2024 16:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970152;
	bh=FLi3OEag2nMlhwJiTtjlx55glieJ4Z7+MFshq2nEC44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EOsd3tKHakTlDPl1PPl+drPRe5e23ULqEhanJ2Q2q4AjZE9kfssaQJ7D/cOZ2tF4G
	 ckGzRVK5xImDlflTLedWEfX8rfMDWfDyxXSwKqDz+v7LTfyWdqu++hDjTJYlcd4LTA
	 PijCPCAcoGIXDg2OVMByhYKV81dq0cZXL+tyT3MU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Jann Horn <jannh@google.com>,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: [PATCH 6.12 146/160] udmabuf: also check for F_SEAL_FUTURE_WRITE
Date: Mon, 23 Dec 2024 16:59:17 +0100
Message-ID: <20241223155414.454177066@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit 0a16e24e34f28210f68195259456c73462518597 upstream.

When F_SEAL_FUTURE_WRITE was introduced, it was overlooked that udmabuf
must reject memfds with this flag, just like ones with F_SEAL_WRITE.
Fix it by adding F_SEAL_FUTURE_WRITE to SEALS_DENIED.

Fixes: ab3948f58ff8 ("mm/memfd: add an F_SEAL_FUTURE_WRITE seal to memfd")
Cc: stable@vger.kernel.org
Acked-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241204-udmabuf-fixes-v2-2-23887289de1c@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma-buf/udmabuf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -256,7 +256,7 @@ static const struct dma_buf_ops udmabuf_
 };
 
 #define SEALS_WANTED (F_SEAL_SHRINK)
-#define SEALS_DENIED (F_SEAL_WRITE)
+#define SEALS_DENIED (F_SEAL_WRITE|F_SEAL_FUTURE_WRITE)
 
 static int check_memfd_seals(struct file *memfd)
 {


