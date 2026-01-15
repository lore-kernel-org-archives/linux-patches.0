Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB613BF301;
	Thu, 15 Jan 2026 17:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497032; cv=none; b=EHjYKCw2s45ppGmkInMh/0QM5zwfiL5fAsKLx4WDoPSKSHgzsBbPKtyaNTkOsDkS9LdMZcK53nv8ApGURD6UTs9THUMoVTVcidfiDlrbcptC4IfsV3hpXfn/YducZ9AfoE6/JweYwwWWBab/u0ji5d7gOFMOEWRBdW2A7NHVPe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497032; c=relaxed/simple;
	bh=33Y9Kf0QUW/p8U8yMNJtqDzmUwUGiDza9mEX0H6QfDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bKL07GGtNVV20y4n9MzLQNYYlCYZZmyTGPRui6NnJsxWv5lQh2ox9nYACGqd8vNYC64hK0ojugj+rrK16TRXX0ZXJQTt/Z01WZHbbeLk5qADb60tCHsKpzFHfp5gqkpX/Df52zQ35zHnzZ4vjIhYOQPPXW+MmMta2BabRxgt2jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WeU/KcqO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WeU/KcqO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F905C16AAE;
	Thu, 15 Jan 2026 17:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497031;
	bh=33Y9Kf0QUW/p8U8yMNJtqDzmUwUGiDza9mEX0H6QfDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WeU/KcqOtVaEYFuLkYZp8VSLegKnP71hiDjTCVaaLq8liooCM6Tc1xP2eDzp+4SuC
	 VSmNLFSbX5eU4pCtwcONS/2H7KEz9b5/+37SAsNb7AEsGYPP0ddmKoBzDyQlLfpmRe
	 aBJFN3xY8XtdGprZBLqSNuhljwrLf6zKH7Guk+f0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Subject: [PATCH 6.1 13/72] libceph: return the handler error from mon_handle_auth_done()
Date: Thu, 15 Jan 2026 17:48:23 +0100
Message-ID: <20260115164143.972393092@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
References: <20260115164143.482647486@linuxfoundation.org>
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

From: Ilya Dryomov <idryomov@gmail.com>

commit e84b48d31b5008932c0a0902982809fbaa1d3b70 upstream.

Currently any error from ceph_auth_handle_reply_done() is propagated
via finish_auth() but isn't returned from mon_handle_auth_done().  This
results in higher layers learning that (despite the monitor considering
us to be successfully authenticated) something went wrong in the
authentication phase and reacting accordingly, but msgr2 still trying
to proceed with establishing the session in the background.  In the
case of secure mode this can trigger a WARN in setup_crypto() and later
lead to a NULL pointer dereference inside of prepare_auth_signature().

Cc: stable@vger.kernel.org
Fixes: cd1a677cad99 ("libceph, ceph: implement msgr2.1 protocol (crc and secure modes)")
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/mon_client.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -1417,7 +1417,7 @@ static int mon_handle_auth_done(struct c
 	if (!ret)
 		finish_hunting(monc);
 	mutex_unlock(&monc->mutex);
-	return 0;
+	return ret;
 }
 
 static int mon_handle_auth_bad_method(struct ceph_connection *con,


