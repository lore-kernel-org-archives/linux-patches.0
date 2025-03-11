Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA00A25DAEC;
	Tue, 11 Mar 2025 15:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706898; cv=none; b=rAzD/LQMPHEpW1Gl3IRbfGAs98XSlBF2nTTjtpPiq4OBXl1QXgzHexWFOjKRQO/eyu5Y5iFhYi8PA4P4X3E98rTlQA84WiD3W44IlsKed+kQtga/Qj3TBGQMlYlc8jmROww4/w0DONIX/vivvUBj80APDjYL9Vs2RWoL4zaOFm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706898; c=relaxed/simple;
	bh=VmZK8qrSldPJOaAMjvc/XEl7QrT/Tz6XRzYOxXL6RrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UpqfYf6e5XdInvapT38y8hbrJM8BbL7IXiji7N2Jbz9MA4C9Riier7Wb89Q5lRgDjr6jTIM5IzWsR/Y09XgI9PwI4+O7Q5grCi4msmDRioTdfFJmb6zMGrpIza0DlSVovZrGN/D7PiK4ESq0yWN1lLq4I5J1bWXYUaUDSr3wB5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DtHocMv0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DtHocMv0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9DACC4CEE9;
	Tue, 11 Mar 2025 15:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706898;
	bh=VmZK8qrSldPJOaAMjvc/XEl7QrT/Tz6XRzYOxXL6RrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DtHocMv0mlm9TQtWOeJ/oaquSv1c2hIuH2uk5OqIShSYtr8bWYoWraF/kr7+VGXJx
	 qXrQ12Hv1YA+KW0qGMHrFWakUcJGjMrNqIE17vv+DNVWdmf8M/mxdv7DEHitb/mXLW
	 4m2NGnW6rIe0hU39bJQqoQCUGEoTVr2PqlT4ltPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Zijun Hu <quic_zijuhu@quicinc.com>
Subject: [PATCH 5.10 178/462] blk-cgroup: Fix class @block_classs subsystem refcount leakage
Date: Tue, 11 Mar 2025 15:57:24 +0100
Message-ID: <20250311145805.386206843@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit d1248436cbef1f924c04255367ff4845ccd9025e upstream.

blkcg_fill_root_iostats() iterates over @block_class's devices by
class_dev_iter_(init|next)(), but does not end iterating with
class_dev_iter_exit(), so causes the class's subsystem refcount leakage.

Fix by ending the iterating with class_dev_iter_exit().

Fixes: ef45fe470e1e ("blk-cgroup: show global disk stats in root cgroup io.stat")
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20250105-class_fix-v6-2-3a2f1768d4d4@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-cgroup.c |    1 +
 1 file changed, 1 insertion(+)

--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -851,6 +851,7 @@ static void blkcg_fill_root_iostats(void
 		}
 		disk_put_part(part);
 	}
+	class_dev_iter_exit(&iter);
 }
 
 static int blkcg_print_stat(struct seq_file *sf, void *v)


