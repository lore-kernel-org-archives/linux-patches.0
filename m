Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2C8332ED8;
	Wed, 26 Nov 2025 17:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764177068; cv=none; b=QS4MekVSPU8o1Y1nYTCvZuNokDBiCbvq6XfR8/dDs0ZNYorA0A3J2NhuVXhmENc/ER8H0151vAMEstQlG0MX4Hn5pnAntAXQ7ud3SC2ZG9dnT7Y3NKxbcl6vFbHeHPVY/J2tjjLK13VGRqcoNsSLBhjj01GqKIP9QXJwuYsvEQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764177068; c=relaxed/simple;
	bh=QBF+YYW5t2985NX2wxCy/g3xMUEi8ZGEmqwfSyzRRHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AJe53kKZ43PtiQIkDRAlUcqYQ0xf1lpfD/jPJUmDw5zKo3TtUIMiIZ9h+8rCMHaxNTN1AQ1XIroGK5zg7LuRCNZU7lQSV7hISP3rTiUO75NwS2lV11s7osfn9c1abZ5jLLmi6FKvl7mAEzK7r8kWxghvMMq3BNtolzOj3juq3Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Wn0+3ndw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Wn0+3ndw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Tux5kDN7yE3/0W03fqJepbKuZcBl5I8I5V7DDUCUdTE=; b=Wn0+3ndw35a8HHujUmjx18LX0H
	ZXSHN4V8aUlSVvdFzyWkPRzQm1o7D96gdpN8x1C+9TMWbE14scjrh7eTZAzyE2QkQCJZps3jqyR7d
	lA2nL+E/Kj2qehFzaw+wk4zbh8DpQihHM2saoYC1TVD6pIOJqbr5c7Z4bjduxQJG7WRqW/tLkV9us
	IvgKdGMCe+gg8+NZuMypn/iB3Jrz3lxuf2hoZ0EezF7AQSJQ0/oWWn5QKTjJOD+FHQd4oGoDEKdWB
	+yy+FqJa0UYXPK6QQngPXNeiRpv8ZQgedUCB1ZCqgFRAaF/5GNbWRxgWUpwwVRDHU/4fEtdzYMbuf
	e+MGajAA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOJ2m-0000000FNAK-1Q5m;
	Wed, 26 Nov 2025 17:11:04 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: shinichiro.kawasaki@wdc.com
Cc: linux-block@vger.kernel.org,
	patches@lists.linux.dev,
	gost.dev@samsung.com,
	sw.prabhu6@gmail.com,
	kernel@pankajraghav.com,
	bvanassche@acm.org,
	mcgrof@kernel.org,
	Chaitanya Kulkarni <kch@nvidia.com>
Subject: [PATCH v4 1/2] blktests: replace module removal with patient module removal
Date: Wed, 26 Nov 2025 09:11:01 -0800
Message-ID: <20251126171102.3663957-2-mcgrof@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251126171102.3663957-1-mcgrof@kernel.org>
References: <20251126171102.3663957-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

A long time ago, in a galaxy far, far away...

I ran into some odd scsi_debug false positives with fstests. This
prompted me to look into them given these false positives prevents
me from moving forward with establishing a test baseline with high
number of cycles. That is, this stupid issue was prevening creating
high confidence in testing.

I reported it [0] and exchanged some ideas with Doug. However, in
the end, despite efforts to help things with scsi_debug there were
still issues lingering which seemed to defy our expectations upstream.
One of the last hanging fruit issues is and always has been that
userspace expectations for proper module removal has been broken,
so in the end I have demonstrated this is a generic issue [1].

Long ago a WAIT option for module removal was added... that was then
removed as it was deemed not needed as folks couldn't figure out when
these races happened. The races are actually pretty easy to trigger, it
was just never properly documented. A simpe blkdev_open() will easily
bump a module refcnt, and these days many thing scan do that sort of
thing.

The proper solution is to implement then a patient module removal
on kmod and that has been merged now as modprobe --wait=MSEC option.
We need a work around to open code a similar solution for users of
old versions of kmod. An open coded solution for fstests exists
there for over a year now. This now provides the respective blktests
implementation.

[0] https://bugzilla.kernel.org/show_bug.cgi?id=212337
[1] https://bugzilla.kernel.org/show_bug.cgi?id=214015

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Rebased-by: Claude AI
---
 common/multipath-over-rdma |  11 +---
 common/null_blk            |   6 +-
 common/nvme                |   9 +--
 common/rc                  | 126 +++++++++++++++++++++++++++++++++++++
 common/scsi_debug          |  14 ++---
 tests/srp/rc               |   4 +-
 6 files changed, 145 insertions(+), 25 deletions(-)

diff --git a/common/multipath-over-rdma b/common/multipath-over-rdma
index 1084f80..d082700 100644
--- a/common/multipath-over-rdma
+++ b/common/multipath-over-rdma
@@ -4,6 +4,7 @@
 #
 # Functions and global variables used by the srp tests.
 
+. common/rc
 . common/shellcheck
 . common/null_blk
 
@@ -427,14 +428,8 @@ stop_soft_rdma() {
 		      echo "$i ..."
 		      rdma link del "${i}" || echo "Failed to remove ${i}"
 		done
-	if ! _unload_module rdma_rxe 10; then
-		echo "Unloading rdma_rxe failed"
-		return 1
-	fi
-	if ! _unload_module siw 10; then
-		echo "Unloading siw failed"
-		return 1
-	fi
+	_patient_rmmod rdma_rxe || return 1
+	_patient_rmmod siw  || return 1
 	} >>"$FULL"
 }
 
diff --git a/common/null_blk b/common/null_blk
index bbb6f78..f5fccc1 100644
--- a/common/null_blk
+++ b/common/null_blk
@@ -5,6 +5,7 @@
 # null_blk helper functions.
 
 . common/shellcheck
+. common/rc
 
 _have_null_blk() {
 	_have_driver null_blk
@@ -38,7 +39,8 @@ _init_null_blk() {
 	local args=("$@")
 	if (( RUN_FOR_ZONED )); then args+=("zoned=1"); fi
 
-	if ! modprobe -r null_blk || ! modprobe null_blk "${args[@]}" ; then
+	_patient_rmmod null_blk || return 1
+	if ! modprobe null_blk "${args[@]}"; then
 		SKIP_REASONS+=("requires modular null_blk")
 		return 1
 	fi
@@ -79,5 +81,5 @@ _configure_null_blk() {
 _exit_null_blk() {
 	_remove_null_blk_devices
 	udevadm settle
-	modprobe -r -q null_blk
+	_patient_rmmod null_blk
 }
diff --git a/common/nvme b/common/nvme
index 3d43790..049850e 100644
--- a/common/nvme
+++ b/common/nvme
@@ -4,6 +4,7 @@
 # nvme helper functions.
 
 . common/shellcheck
+. common/rc
 
 def_traddr="127.0.0.1"
 def_adrfam="ipv4"
@@ -210,13 +211,13 @@ _cleanup_nvmet() {
 
 	if [[ "${nvme_trtype}" == "fc" ]]; then
 		_nvme_fcloop_del_lport "${def_local_wwnn}" "${def_local_wwpn}"
-		modprobe -rq nvme-fcloop 2>/dev/null
+		_patient_rmmod nvme-fcloop
 	fi
-	modprobe -rq nvme-"${nvme_trtype}" 2>/dev/null
+	_patient_rmmod nvme-"${nvme_trtype}"
 	if [[ "${nvme_trtype}" != "loop" ]]; then
-		modprobe -rq nvmet-"${nvme_trtype}" 2>/dev/null
+		_patient_rmmod nvmet-"${nvme_trtype}"
 	fi
-	modprobe -rq nvmet 2>/dev/null
+	_patient_rmmod nvmet
 	if [[ "${nvme_trtype}" == "rdma" ]]; then
 		stop_soft_rdma
 	fi
diff --git a/common/rc b/common/rc
index ea92970..556581f 100644
--- a/common/rc
+++ b/common/rc
@@ -736,3 +736,129 @@ _min() {
 	done
 	echo "$ret"
 }
+
+_has_modprobe_patient()
+{
+	modprobe --help >& /dev/null || return 1
+	modprobe --help | grep -q "\-\-wait" || return 1
+	return 0
+}
+
+# Check whether modprobe --wait is supported and set up the patient module
+# remover command. This is evaluated at source time, so we need to handle
+# the timeout dynamically in _patient_rmmod() for cases where tests want
+# to override it.
+MODPROBE_HAS_WAIT=""
+if _has_modprobe_patient; then
+	MODPROBE_HAS_WAIT="yes"
+fi
+
+if [[ -z "$MODPROBE_PATIENT_RM_TIMEOUT_SECONDS" ]]; then
+	export MODPROBE_PATIENT_RM_TIMEOUT_SECONDS="50"
+fi
+
+# checks the refcount and returns 0 if we can safely remove the module. rmmod
+# does this check for us, but we can use this to also iterate checking for this
+# refcount before we even try to remove the module. This is useful when using
+# debug test modules which take a while to quiesce.
+_patient_rmmod_check_refcnt()
+{
+	local module=$1
+	local refcnt=0
+
+	refcnt=$(cat "/sys/module/$module/refcnt" 2>/dev/null)
+	if [[ $? -ne 0 || $refcnt -eq 0 ]]; then
+		return 0
+	fi
+	return 1
+}
+
+# Tries to wait patiently to remove a module by ensuring first
+# the refcnt is 0 and then trying to remove the module over and over
+# again within the time allowed. The timeout is configurable per test, just set
+# MODPROBE_PATIENT_RM_TIMEOUT_SECONDS prior to calling this function.
+# This applies to both cases where kmod supports the patient module remover
+# (modprobe --wait) and where it does not.
+#
+# If your version of kmod supports modprobe --wait, we use that instead.
+# Otherwise we have to implement a patient module remover ourselves.
+_patient_rmmod()
+{
+	local module=$1
+	local max_tries_max=$MODPROBE_PATIENT_RM_TIMEOUT_SECONDS
+	local max_tries=0
+	local mod_ret=0
+	local refcnt_is_zero=0
+	# Since we are looking for a directory we must adopt the
+	# specific directory used by scripts/Makefile.lib for
+	# KBUILD_MODNAME
+	local module_sys=${module//-/_}
+
+	# Check if module is built-in or not loaded
+	if [[ ! -d "/sys/module/$module_sys" ]]; then
+		return 0
+	fi
+
+	# Check if this is a built-in module (no refcnt file means built-in)
+	if [[ ! -f "/sys/module/$module_sys/refcnt" ]]; then
+		return 0
+	fi
+
+	if [[ -n $MODPROBE_HAS_WAIT ]]; then
+		local timeout_ms=$((MODPROBE_PATIENT_RM_TIMEOUT_SECONDS * 1000))
+		modprobe -r --wait="${timeout_ms}" "$module"
+		mod_ret=$?
+		if [[ $mod_ret -ne 0 ]]; then
+			echo "kmod patient module removal for $module timed out waiting for refcnt to become 0 using timeout of $max_tries_max returned $mod_ret"
+		fi
+		return $mod_ret
+	fi
+
+	max_tries=$max_tries_max
+
+	while [[ "$max_tries" != "0" ]]; do
+		if _patient_rmmod_check_refcnt "$module_sys"; then
+			refcnt_is_zero=1
+			break
+		fi
+		sleep 1
+		((max_tries--))
+	done
+
+	if [[ $refcnt_is_zero -ne 1 ]]; then
+		echo "custom patient module removal for $module timed out waiting for refcnt to become 0 using timeout of $max_tries_max"
+		return 1
+	fi
+
+	# If we ran out of time but our refcnt check confirms we had
+	# a refcnt of 0, just try to remove the module once.
+	if [[ "$max_tries" == "0" ]]; then
+		modprobe -r "$module"
+		return $?
+	fi
+
+	# If we have extra time left. Use the time left to now try to
+	# persistently remove the module. We do this because although through
+	# the above we found refcnt to be 0, removal can still fail since
+	# userspace can always race to bump the refcnt. An example is any
+	# blkdev_open() calls against a block device. These issues have been
+	# tracked and documented in the following bug reports, which justifies
+	# our need to do this in userspace:
+	# https://bugzilla.kernel.org/show_bug.cgi?id=212337
+	# https://bugzilla.kernel.org/show_bug.cgi?id=214015
+	while [[ $max_tries != 0 ]] && [[ -d /sys/module/$module_sys ]]; do
+		modprobe -r "$module" 2> /dev/null
+		mod_ret=$?
+		if [[ $mod_ret == 0 ]]; then
+			break;
+		fi
+		sleep 1
+		((max_tries--))
+	done
+
+	if [[ $mod_ret -ne 0 ]]; then
+		echo "custom patient module removal for $module timed out trying to remove using timeout of $max_tries_max last try returned $mod_ret"
+	fi
+
+	return $mod_ret
+}
diff --git a/common/scsi_debug b/common/scsi_debug
index 89c4801..5f40aa4 100644
--- a/common/scsi_debug
+++ b/common/scsi_debug
@@ -4,6 +4,8 @@
 #
 # scsi_debug helper functions.
 
+. common/rc
+
 _have_scsi_debug() {
 	_have_driver scsi_debug
 }
@@ -98,14 +100,8 @@ _init_scsi_debug() {
 		args+=(zbc=host-managed zone_nr_conv=0)
 	fi
 
-	if ! _unload_module scsi_debug 10; then
-		echo "Unloading scsi_debug failed" >&2
-		return 1
-	fi
-	if ! modprobe scsi_debug "${args[@]}"; then
-		echo "Loading scsi_debug ${args[*]} failed" >&2
-		return 1
-	fi
+	_patient_rmmod scsi_debug || return 1
+	modprobe scsi_debug "${args[@]}" || return 1
 
 	udevadm settle
 
@@ -180,7 +176,7 @@ _exit_scsi_debug() {
 	udevadm settle
 
 	if _module_file_exists scsi_debug; then
-		_unload_module scsi_debug 10
+		_patient_rmmod scsi_debug
 		return
 	fi
 
diff --git a/tests/srp/rc b/tests/srp/rc
index 47b9546..8585272 100755
--- a/tests/srp/rc
+++ b/tests/srp/rc
@@ -502,7 +502,7 @@ start_lio_srpt() {
 	if modinfo ib_srpt | grep -q '^parm:[[:blank:]]*rdma_cm_port:'; then
 		opts+=("rdma_cm_port=${srp_rdma_cm_port}")
 	fi
-	_unload_module ib_srpt
+	_patient_rmmod ib_srpt
 	modprobe ib_srpt "${opts[@]}" || return $?
 	i=0
 	for r in "${vdev_path[@]}"; do
@@ -564,7 +564,7 @@ stop_lio_srpt() {
 			 target_core_file target_core_stgt target_core_user \
 			 target_core_mod
 	do
-		_unload_module $m 10 || return $?
+		_patient_rmmod $m || return $?
 	done
 }
 
-- 
2.51.0

