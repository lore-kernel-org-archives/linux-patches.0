Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119E219DF53;
	Tue, 16 Jul 2024 15:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145242; cv=none; b=FG6mbeFt+A47/dgeBnNtcteWDzVFUrrFJj+nTVU4LYzfkCMotjnaZS5rDAmQu1nekLSJYjB07g7S385o6dhey4UzbUZe5iZp06aSCLPmS0/IQ1UATGu6IpT5wiFT7hrNAQTMY1CR6vyu9SJ6YxTnR2IJuhmrfoo8dWkXYMXSX24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145242; c=relaxed/simple;
	bh=f50AAW8lo9EK7f5MDU89hrn6DFhj4DmK/RfmRqNWh+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=COb4glVl4pEI4/QJOawECGlyVxQxLoyyACr6RZDaaUOegbwbiyIvoLiL8AZNJUwoOncgTKhsElbSr1W1QnJ9EjjtvrYV1PhQ9HZ6PORBcJ3ZQrlmzOtQUMCtxaLtqD9wW521iLsyZBulVweJoKtYFFBhNiPaq974B+fr5PnZsGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lzVhD4b7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lzVhD4b7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A0C7C4AF11;
	Tue, 16 Jul 2024 15:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145241;
	bh=f50AAW8lo9EK7f5MDU89hrn6DFhj4DmK/RfmRqNWh+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lzVhD4b71sSrrH05ZTxcuX5uvd6TqvfbWQ2KEPH2v8pgI7LKRTSTWv5eqPJavmzu/
	 EJYA1Gjn1yOnhtNPjZ9JWf/MR2u5z+aaBV4Gcni+gWDsquL9373k8qJl94w/9c+3hQ
	 4v6EwY1w3IFkS2NkgerNxygW6O7oQ/9i/8IvDnZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ekansh Gupta <quic_ekangupt@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.9 127/143] misc: fastrpc: Fix memory leak in audio daemon attach operation
Date: Tue, 16 Jul 2024 17:32:03 +0200
Message-ID: <20240716152800.872729057@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ekansh Gupta <quic_ekangupt@quicinc.com>

commit ad0bd973a033003ca578c42a760d1dc77aeea15e upstream.

Audio PD daemon send the name as part of the init IOCTL call. This
name needs to be copied to kernel for which memory is allocated.
This memory is never freed which might result in memory leak. Free
the memory when it is not needed.

Fixes: 0871561055e6 ("misc: fastrpc: Add support for audiopd")
Cc: stable <stable@kernel.org>
Signed-off-by: Ekansh Gupta <quic_ekangupt@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20240628114501.14310-5-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -1320,6 +1320,7 @@ static int fastrpc_init_create_static_pr
 		goto err_invoke;
 
 	kfree(args);
+	kfree(name);
 
 	return 0;
 err_invoke:


