Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA9C168C4;
	Mon, 27 May 2024 19:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837426; cv=none; b=T1hNhzohu/NTn0xvTWBHBaQvzqf7zbjQDhZ9dQrJmXsRxVJg9GcPz2AJnag0LowCGaIOq6TD3H06f+OM/inrbaYWm6qEWXC6H+KSyeGjmK98EKYsOZnJgJfShU4wrC4wOnSPC2djdbxNnQLW9CIbMe/Fm6HGiyRq0tqmdQ+3ZhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837426; c=relaxed/simple;
	bh=GuN1AZX5yxrPuT26CeOF/GTtJ7r8h4yYS9QnKrK6ZJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EI+U4viQExsRXwxIV/seHmR7pqG7UFkksEGTs3mzimnvVwAsLR6wwaSOL0XqGY7I4FzYG+GEmyTHoNkeqAkZTXHkMUdiQIeID4ahDkOEmE6soBy0CjlpPri6Pb9E8dyrgzip3zFVobgNp8SCkCuCnm3YiYlf+vZRK53LFGDdN0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kOh/FsMI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kOh/FsMI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E615C2BBFC;
	Mon, 27 May 2024 19:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837425;
	bh=GuN1AZX5yxrPuT26CeOF/GTtJ7r8h4yYS9QnKrK6ZJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kOh/FsMIvz28c1ZaykvZ6bdZDxwFNWKb2ZQV6LA2VGMjo3hINtz7Rcd4GE/0iwiBr
	 UveuQlYE1qzzkj18N+p9yiIVJD2F6LlPv5NE1f19GD1dvXoJjNwOEHup3EKsy+Y11A
	 M2WE/qvK+065REoU94Hex/nx2O+7fhIOQ9kU7Goc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.8 001/493] sunrpc: use the struct net as the svc proc private
Date: Mon, 27 May 2024 20:50:03 +0200
Message-ID: <20240527185626.682025588@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit 418b9687dece5bd763c09b5c27a801a7e3387be9 upstream.

nfsd is the only thing using this helper, and it doesn't use the private
currently.  When we switch to per-network namespace stats we will need
the struct net * in order to get to the nfsd_net.  Use the net as the
proc private so we can utilize this when we make the switch over.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/stats.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sunrpc/stats.c
+++ b/net/sunrpc/stats.c
@@ -314,7 +314,7 @@ EXPORT_SYMBOL_GPL(rpc_proc_unregister);
 struct proc_dir_entry *
 svc_proc_register(struct net *net, struct svc_stat *statp, const struct proc_ops *proc_ops)
 {
-	return do_register(net, statp->program->pg_name, statp, proc_ops);
+	return do_register(net, statp->program->pg_name, net, proc_ops);
 }
 EXPORT_SYMBOL_GPL(svc_proc_register);
 


