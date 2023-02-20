Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307FB63B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:54:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93514C433D2;
	Mon, 20 Feb 2023 13:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901249;
	bh=HGXOPkJV5VI+3Fy/YNsHIQd8deUfwoH/F63MFBoZN8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vVlBP6pvl6h1S0J3ZMTAVf9KYJl0Nm1spqC/YjF0Qdc3OUBx+t3xsF8DxhpIb7Slc
	 jm8Rn4r2rtGQUaBVGFfY4jivCva07K0mZ6NpuoiyKIytphQhIK6QBeY/20Dgc3GNmB
	 w0av5hfXL+jjpEYtEeGC7Jlby85wG8gN5bTu0kS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangyu Hua <hbh25y@gmail.com>,
	Eelco Chaudron <echaudro@redhat.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 63/83] net: openvswitch: fix possible memory leak in ovs_meter_cmd_set()
Date: Mon, 20 Feb 2023 14:36:36 +0100
Message-Id: <20230220133555.874789848@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
References: <20230220133553.669025851@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hangyu Hua <hbh25y@gmail.com>

commit 2fa28f5c6fcbfc794340684f36d2581b4f2d20b5 upstream.

old_meter needs to be free after it is detached regardless of whether
the new meter is successfully attached.

Fixes: c7c4c44c9a95 ("net: openvswitch: expand the meters supported number")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Acked-by: Eelco Chaudron <echaudro@redhat.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/meter.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/openvswitch/meter.c
+++ b/net/openvswitch/meter.c
@@ -450,7 +450,7 @@ static int ovs_meter_cmd_set(struct sk_b
 
 	err = attach_meter(meter_tbl, meter);
 	if (err)
-		goto exit_unlock;
+		goto exit_free_old_meter;
 
 	ovs_unlock();
 
@@ -473,6 +473,8 @@ static int ovs_meter_cmd_set(struct sk_b
 	genlmsg_end(reply, ovs_reply_header);
 	return genlmsg_reply(reply, info);
 
+exit_free_old_meter:
+	ovs_meter_free(old_meter);
 exit_unlock:
 	ovs_unlock();
 	nlmsg_free(reply);


