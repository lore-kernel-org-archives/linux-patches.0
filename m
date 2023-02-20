Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564BC63BB
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 14:00:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0CDFC433D2;
	Mon, 20 Feb 2023 14:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901637;
	bh=oLcRIn3TJsyjkUWLg52UIrePt94uabO3gFWCjh3Ut4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gjTGcfnAz1DKHbVD5RzVDPmi348aB6n2FGqD5A9crht8MurRy5C3/C+6E9S5DTls7
	 I88tMw9b6eP+ihR3nbGQDzYvzNdFcKMI/fj5DCx30WvkrJlab6I80lGYyJvoSyFX9t
	 8Y8WgU5lFffF63/IqeJrw3O0hxGNvg/KyRpD3yOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangyu Hua <hbh25y@gmail.com>,
	Eelco Chaudron <echaudro@redhat.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 092/118] net: openvswitch: fix possible memory leak in ovs_meter_cmd_set()
Date: Mon, 20 Feb 2023 14:36:48 +0100
Message-Id: <20230220133604.080343375@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
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
@@ -449,7 +449,7 @@ static int ovs_meter_cmd_set(struct sk_b
 
 	err = attach_meter(meter_tbl, meter);
 	if (err)
-		goto exit_unlock;
+		goto exit_free_old_meter;
 
 	ovs_unlock();
 
@@ -472,6 +472,8 @@ static int ovs_meter_cmd_set(struct sk_b
 	genlmsg_end(reply, ovs_reply_header);
 	return genlmsg_reply(reply, info);
 
+exit_free_old_meter:
+	ovs_meter_free(old_meter);
 exit_unlock:
 	ovs_unlock();
 	nlmsg_free(reply);


